import MysqlDBC from "../db/myslq/MysqlDBC";

import { json } from "express";

export default class UserModel {

    private mysqlDBC: MysqlDBC;

    constructor() {
        this.mysqlDBC = new MysqlDBC();
    }
    
    public InsertUser = async (nombre: string, apellidos: string, email: string, telefono: string ,passwd: string, fn: Function) => {
        this.mysqlDBC.connection();

        const statement = `INSERT INTO users(nombres,apellidos,email,telefono,passwd) VALUES ('${nombre}', '${apellidos}','${email}','${telefono}','${passwd}');`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public getUser = async (email: string, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT * FROM users WHERE email='${email}'`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }


}