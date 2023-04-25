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

    public getIdCategoriasTrabajos = async (nombre: string, fn: Function) => {
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

    public getCategorias = async (fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT nombres FROM categorias;`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }


    public postSolicitudEmpleador = async (id: number,titulo:string,descripcion:string, id_categorias: number, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `INSERT INTO solicitud(estado,titulo,descripcion,categorias_idcategorias,empleador_idempleador) VALUES ('Buscando','${titulo}','${descripcion}',${id_categorias},${id});`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public postSolicitudTrabajadorPostularse = async (idSolicitud: number, idTrabajador: number, fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `INSERT INTO postulantes(solicitud_idsolicitud,trabajador_idtrabajador) VALUES (${idSolicitud},${idTrabajador});`;
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
        const statement = `SELECT idsolicitud,titulo, descripcion, nombres FROM solicitud, categorias WHERE trabajador_idtrabajador IS null AND estado='Buscando' AND categorias_idcategorias=idcategorias;`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public getSolicitudesPorCategoria = async (categoria: string,fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT idsolicitud,titulo, descripcion, nombres FROM solicitud, categorias WHERE trabajador_idtrabajador IS null AND estado='Buscando' AND nombres='${categoria}';`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    //Obtener los postulantes para una solicitud
    public getPostulantesSolicitud = async (solicitud: number,fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT idtrabajador,nombres,apellidos,telefono,trabajo,descripcion FROM postulantes,trabajador WHERE solicitud_idsolicitud=${solicitud} AND trabajador_idtrabajador=idtrabajador;;`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    //Verifica si la solicitud si es del empelador
    public verificarEmpleadorSolicitud = async (id: number,fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT empleador_idempleador FROM solicitud WHERE idsolicitud=${id};`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public getTrabajadores = async (fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT A.nombres,apellidos,telefono,trabajo,descripcion,B.nombres AS categoria FROM trabajador AS A, categorias AS B WHERE categorias_idcategorias=idcategorias;`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }


    //Obtener trabajadores por categoria
    public getTrabajadoresPorCategoria = async (categoria: string,fn: Function) => {
        this.mysqlDBC.connection();
        const statement = `SELECT A.nombres,apellidos,telefono,trabajo,descripcion,B.nombres AS categoria FROM trabajador AS A, categorias AS B WHERE B.nombres='${categoria}';`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    //El empleador acepta al trabajador
    public AceptarTrabajador = async (idTrabajador: number,idSolicitud: number,fn: Function) => {
        this.mysqlDBC.connection();

        this.mysqlDBC.pool.query(`DELETE FROM postulantes WHERE solicitud_idsolicitud=${idSolicitud};`,(error:any, rows: any)=> {});
        const statement = `Update solicitud Set estado='En progreso',trabajador_idtrabajador=${idTrabajador} Where idsolicitud=${idSolicitud};`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    //Obtener solicitudes hechas por un empleador
    public getMisSolicitudesEmpleador = async (idEmpleador: number,fn: Function) => {
        this.mysqlDBC.connection();

        const statement = `SELECT idsolicitud, titulo, descripcion, nombres, estado FROM solicitud, categorias WHERE empleador_idempleador=${idEmpleador};`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    
    

}