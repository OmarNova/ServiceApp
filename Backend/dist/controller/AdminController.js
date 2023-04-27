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
const AdminModel_1 = __importDefault(require("../model/AdminModel"));
const path_1 = __importDefault(require("path"));
const dotenv = __importStar(require("dotenv"));
dotenv.config();
class UserController {
    constructor() {
        this.index = (req, res) => res.json({ 'error': 0, 'msg': 'API: node-express-ts' });
        this.insertCategoria = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { nombre } = req.body;
            this.model.InsertCategoriaTrabajo(nombre, (error, rows) => {
                if (error) {
                    console.error(error);
                    return { error: true, message: 'error database' };
                }
                return res.json({ error: false, message: 'Ok' });
            });
        });
        this.deleteCategoria = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { nombre } = req.params;
            this.model.DeleteCategoriaTrabajo(nombre, (error, rows) => {
                if (error) {
                    console.error(error);
                    return { error: true, message: 'error database' };
                }
                return res.json({ error: false, message: 'Ok' });
            });
        });
        this.VistaAdmin = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const archivo = path_1.default.join(__dirname + "/../View/admin.html");
            return res.sendFile(archivo);
        });
        this.model = new AdminModel_1.default();
    }
}
exports.default = UserController;
