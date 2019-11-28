import { Request, Response } from "express";
import * as jwt from "jsonwebtoken";
import { getRepository } from "typeorm";
import { validate } from "class-validator";
import { user } from "../entities/user";
import config from "../config/config";
import { hashPassword, checkIfUnencryptedPasswordIsValid } from "../utils";



class AuthController {
  static login = async (req: Request, res: Response) => {
    //Check if username and password are set
    let { username, password } = req.body;
    if (!(username && password)) {
      res.status(400).send();
    }

    //Get user from database
    const userRepository = getRepository(user);
    let foundUser: user;
    try {
      foundUser = await userRepository.findOneOrFail({ where: { username } });
    } catch (error) {
      res.status(401).send();
    }

    //Check if encrypted password match
    if (!checkIfUnencryptedPasswordIsValid(password, foundUser.password)) {
      res.status(401).send();
      return;
    }

    //Sing JWT, valid for 1 hour
    const token = jwt.sign(
      { userId: foundUser.id, email: foundUser.email },
      config.jwtSecret,
      { expiresIn: "1h" }
    );

    //Send the jwt in the response
    res.send(token);
  };

  static changePassword = async (req: Request, res: Response) => {
    //Get ID from JWT
    const id = res.locals.jwtPayload.userId;

    //Get parameters from the body
    const { oldPassword, newPassword } = req.body;
    if (!(oldPassword && newPassword)) {
      res.status(400).send();
    }

    //Get user from the database
    const userRepository = getRepository(user);
    let foundUser: user;
    try {
      foundUser = await userRepository.findOneOrFail(id);
    } catch (id) {
      res.status(401).send();
    }

    //Check if old password matchs
    if (!checkIfUnencryptedPasswordIsValid(oldPassword, foundUser.password)) {
      res.status(401).send();
      return;
    }

    //Validate de model (password lenght)
    foundUser.password = newPassword;
    const errors = await validate(user);
    if (errors.length > 0) {
      res.status(400).send(errors);
      return;
    }
    //Hash the new password and save
    foundUser.password = hashPassword(newPassword);
    userRepository.save(foundUser);

    res.status(204).send();
  };
}
export default AuthController;
