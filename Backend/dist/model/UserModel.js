"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const MysqlDBC_1 = __importDefault(require("../db/myslq/MysqlDBC"));
class UserModel {
    constructor() {
        this.InsertEmpleador = (nombre, apellidos, email, telefono, passwd, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `INSERT INTO empleador(nombres,apellidos,email,telefono,passwd) VALUES ('${nombre}', '${apellidos}','${email}','${telefono}','${passwd}');`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getIdCategoriasTrabajos = (nombre, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT idcategorias FROM categorias WHERE nombres='${nombre}';`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.InsertTrabajador = (nombre, apellidos, email, telefono, trabajo, descripcion, nombre_cat, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `INSERT INTO trabajador(nombres,apellidos,email,telefono, trabajo, descripcion, categorias_idcategorias) VALUES ('${nombre}', '${apellidos}','${email}','${telefono}','${trabajo}','${descripcion}','${nombre_cat}');`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getEmpleador = (email, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT * FROM empleador WHERE email='${email}'`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getCategorias = (fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT nombres FROM categorias;`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.postSolicitudEmpleador = (id, titulo, descripcion, id_categorias, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `INSERT INTO solicitud(estado,titulo,descripcion,categorias_idcategorias,empleador_idempleador) VALUES ('Buscando','${titulo}','${descripcion}',${id_categorias},${id});`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.postSolicitudTrabajadorPostularse = (idSolicitud, idTrabajador, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `INSERT INTO postulantes(solicitud_idsolicitud,trabajador_idtrabajador) VALUES (${idSolicitud},${idTrabajador});`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getTrabajador = (email, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT * FROM trabajador WHERE email='${email}'`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getSolicitudes = (fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT idsolicitud,titulo, descripcion, nombres FROM solicitud, categorias WHERE trabajador_idtrabajador IS null AND estado='Buscando' AND categorias_idcategorias=idcategorias;`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getSolicitudesPorCategoria = (categoria, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT idsolicitud,titulo, descripcion, nombres FROM solicitud, categorias WHERE trabajador_idtrabajador IS null AND estado='Buscando' AND nombres='${categoria}';`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        //Obtener los postulantes para una solicitud
        this.getPostulantesSolicitud = (solicitud, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT idtrabajador,nombres,apellidos,telefono,trabajo,descripcion FROM postulantes,trabajador WHERE solicitud_idsolicitud=${solicitud} AND trabajador_idtrabajador=idtrabajador;;`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        //Verifica si la solicitud si es del empelador
        this.verificarEmpleadorSolicitud = (id, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT empleador_idempleador FROM solicitud WHERE idsolicitud=${id};`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getTrabajadores = (fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT A.nombres,apellidos,telefono,trabajo,descripcion,B.nombres AS categoria FROM trabajador AS A, categorias AS B WHERE categorias_idcategorias=idcategorias;`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        //Obtener trabajadores por categoria
        this.getTrabajadoresPorCategoria = (categoria, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT A.nombres,apellidos,telefono,trabajo,descripcion,B.nombres AS categoria FROM trabajador AS A, categorias AS B WHERE B.nombres='${categoria}';`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        //El empleador acepta al trabajador
        this.AceptarTrabajador = (idTrabajador, idSolicitud, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            this.mysqlDBC.pool.query(`DELETE FROM postulantes WHERE solicitud_idsolicitud=${idSolicitud};`, (error, rows) => { });
            const statement = `Update solicitud Set estado='En progreso',trabajador_idtrabajador=${idTrabajador} Where idsolicitud=${idSolicitud};`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        //Obtener solicitudes hechas por un empleador
        this.getMisSolicitudesEmpleador = (idEmpleador, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT idsolicitud, titulo, descripcion, nombres, estado FROM solicitud, categorias WHERE empleador_idempleador=${idEmpleador};`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.mysqlDBC = new MysqlDBC_1.default();
    }
}
exports.default = UserModel;
