"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
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
const UserModel_1 = __importDefault(require("../model/UserModel"));
const bcrypt_1 = __importDefault(require("bcrypt"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const dotenv = __importStar(require("dotenv"));
dotenv.config();
class UserController {
    constructor() {
        this.index = (req, res) => res.json({ 'error': 0, 'msg': 'API: node-express-ts' });
        this.registerEmpleador = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { nombres, email, passwd, apellidos, telefono } = req.body;
            const password_hash = bcrypt_1.default.hashSync(passwd, 10);
            this.model.getEmpleador(email, (error, rows) => {
                if (error) {
                    console.error(error);
                    return { error: true, message: 'error database' };
                }
                if (rows.length == 0) {
                    this.model.InsertEmpleador(nombres, apellidos, email, telefono, password_hash, (error, rows) => {
                        if (error) {
                            console.error(error);
                            return { error: true, message: 'error database' };
                        }
                        return res.json({ error: false, message: "Ok" });
                    });
                }
                else {
                    return res.json({ error: true, message: 'User Already Exists' });
                }
            });
        });
        this.registerTrabajador = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { email, trabajo, descripcion, categoria } = req.body;
            this.model.getEmpleador(email, (error, rows) => {
                if (error) {
                    console.error(error);
                    return { error: true, message: 'error database' };
                }
                if (rows.length != 0) {
                    this.model.getCategoriasTrabajos(categoria, (err, row) => {
                        if (err) {
                            console.error(err);
                            return { error: true, message: 'error database' };
                        }
                        this.model.InsertTrabajador(rows[0].nombres, rows[0].apellidos, rows[0].email, rows[0].telefono, trabajo, descripcion, row[0].idcategorias, (e, respuesta) => {
                            if (e) {
                                console.error(e);
                                return { error: true, message: 'error database' };
                            }
                            return res.json({ error: false, message: "Ok" });
                        });
                    });
                }
                else {
                    return res.json({ error: true, message: 'User Not Exists' });
                }
            });
        });
        this.login = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { email, passwd } = req.body;
            this.model.getEmpleador(email, (error, rows) => {
                if (error) {
                    console.error(error);
                    return { error: true, message: 'error database' };
                }
                if (rows.length != 0) {
                    const verified = bcrypt_1.default.compareSync(passwd, rows[0].passwd);
                    if (!verified) {
                        return res.json({ error: true, message: "Contraseña Incorrecta!" });
                    }
                    const token = jsonwebtoken_1.default.sign({ email: email }, process.env.key);
                    return res.json({ error: false, message: "Ok", token: token });
                }
                else {
                    return res.status(410).json({ error: true, message: 'User not Found' });
                }
            });
        });
        this.getSolicitudes = (req, res) => __awaiter(this, void 0, void 0, function* () {
            this.model.getSolicitudes((error, rows) => {
                if (error) {
                    console.error(error);
                    return { error: true, message: 'error database' };
                }
                return res.json({ error: false, message: "Ok", solicitudes: rows });
            });
        });
        this.enviarSolicitudEmpleador = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { email, titulo, descripcion } = req.body;
            this.model.getEmpleador(email, (error, rows) => {
                if (error) {
                    console.error(error);
                    return res.status(405).json({ error: true, message: 'error database' });
                }
                if (rows.length != 0) {
                    this.model.postSolicitudEmpleador(rows[0].idempleador, titulo, descripcion, (err, row) => {
                        if (error) {
                            console.error(error);
                            return { error: true, message: 'error database' };
                        }
                        return res.json({ error: false, message: "Ok" });
                    });
                }
                else {
                    return res.status(410).json({ error: true, message: 'User not Found' });
                }
            });
        });
        this.model = new UserModel_1.default();
    }
}
exports.default = UserController;
