"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const UserController_1 = __importDefault(require("../controller/UserController"));
const auth_1 = __importDefault(require("../middleware/auth"));
const auth_image_1 = __importDefault(require("../middleware/auth_image"));
const ApiDocumentController_1 = __importDefault(require("../controller/ApiDocumentController"));
class UserRoute {
    constructor() {
        this.config = () => {
            this.router.get('/', this.UserController.index);
            this.router.post('/empleador/login', this.UserController.login);
            this.router.post('/empleador/register', this.UserController.registerEmpleador);
            this.router.post('/empleador/solicitud', auth_1.default, this.UserController.enviarSolicitudEmpleador);
            this.router.put('/empleador/aceptarTrabajador', auth_1.default, this.UserController.AceptarTrabajador);
            this.router.get('/empleador/propuestas/:idSolicitud', auth_1.default, this.UserController.getSolicitudesPostulantes);
            this.router.get('/empleador/solicitudes', auth_1.default, this.UserController.getMisSolicitudes);
            this.router.post('/empleador/imagen/perfil', auth_1.default, this.UserController.subirImagen);
            this.router.get('/empleador/imagen/perfil', auth_image_1.default, this.UserController.getImagen);
            //this.router.post('/empleador/solicitud/terminada', auth,this.UserController.getMisSolicitudes);
            this.router.post('/trabajador/register', this.UserController.registerTrabajador);
            this.router.post('/trabajador/postularse', auth_1.default, this.UserController.solicitudTrabajadorPostularse);
            this.router.get('/trabajadores', this.UserController.getTrabajadores);
            this.router.get('/trabajadores/buscar/:categoria', this.UserController.getTrabajadoresPorCategoria);
            //this.router.post('/trabajadores/trabajo/finalizado',this.UserController.getTrabajadoresPorCategoria);
            this.router.get('/solicitudes', this.UserController.getSolicitudes);
            this.router.get('/solicitudes/:categoria', this.UserController.getSolicitudesPorCategoria);
            this.router.get('/categorias', this.UserController.getCategorias);
            this.router.get('/documentacion', this.ApiDocument.registerEmpleador);
        };
        this.router = (0, express_1.Router)();
        this.UserController = new UserController_1.default();
        this.ApiDocument = new ApiDocumentController_1.default();
        this.config();
    }
}
exports.default = UserRoute;
