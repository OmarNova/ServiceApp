import MysqlDBC from "../db/myslq/MysqlDBC";

import { json } from "express";

export default class UserModel {

    private mysqlDBC: MysqlDBC;

    constructor() {
        this.mysqlDBC = new MysqlDBC();
    }
    
    public InsertEmpleador = async (nombre: string, apellidos: string, email: string, telefono: string ,passwd: string, fn: Function) => {
        this.mysqlDBC.connection();

        const statement = `INSERT INTO empleador(nombres,apellidos,email,telefono,passwd) VALUES ('${nombre}', '${apellidos}','${email}','${telefono}','${passwd}');`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public getCategoriasTrabajos = async (nombre: string, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT idcategorias FROM categorias WHERE nombres='${nombre}';`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public InsertTrabajador = async (nombre: string, apellidos: string, email: string, telefono: string ,trabajo: string, descripcion: string, nombre_cat: number , fn: Function) => {
        this.mysqlDBC.connection();

        const statement = `INSERT INTO trabajador(nombres,apellidos,email,telefono, trabajo, descripcion, categorias_idcategorias) VALUES ('${nombre}', '${apellidos}','${email}','${telefono}','${trabajo}','${descripcion}','${nombre_cat}');`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public getEmpleador = async (email: string, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT * FROM empleador WHERE email='${email}'`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }


    public postSolicitudEmpleador = async (id: number,titulo:string,descripcion:string, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `INSERT INTO solicitud(estado,titulo,descripcion,empleador_idempleador) VALUES ('Buscando','${titulo}','${descripcion}',${id});`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }


    public getTrabajador = async (email: string, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT * FROM trabajador WHERE email='${email}'`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public getSolicitudes = async (fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT titulo, descripcion FROM solicitud WHERE trabajador_idtrabajador IS null AND estado='Buscando';`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }



}