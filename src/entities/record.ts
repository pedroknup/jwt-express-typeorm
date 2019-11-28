import {BaseEntity,Column,Entity,Index,JoinColumn,JoinTable,ManyToMany,ManyToOne,OneToMany,OneToOne,PrimaryColumn,PrimaryGeneratedColumn,RelationId} from "typeorm";
import {user} from "./user";


@Entity("record" ,{schema:"pk-boilerplate" } )
@Index("recordUser_idx",["idUser",])
export class record {

    @PrimaryGeneratedColumn({
        type:"int", 
        name:"idRecord"
        })
    idRecord:number;
        

   
    @ManyToOne(()=>user, (user: user)=>user.records,{  nullable:false,onDelete: 'RESTRICT',onUpdate: 'RESTRICT' })
    @JoinColumn({ name:'idUser'})
    idUser:user | null;


    @Column("varchar",{ 
        nullable:false,
        length:18,
        name:"hashId"
        })
    hashId:string;
        

    @Column("varchar",{ 
        nullable:true,
        length:70,
        name:"publicURL"
        })
    publicURL:string | null;
        
}
