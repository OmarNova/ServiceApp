import { Router } from "express";
import UserController from "../controller/UserController"
import auth from "../middleware/auth";
import ApiDocument from "../controller/ApiDocumentController"
import multer from "../middleware/multer";

class UserRoute {

    public router: Router;
    private UserController: UserController;
    private ApiDocument: ApiDocument;

    constructor() {
        this.router = Router();
        this.UserController = new UserController();
        this.ApiDocument = new ApiDocument();
        this.config();
    }

    public config = (): void => {
        this.router.get('/', this.UserController.index);

        this.router.post('/empleador/login', this.UserController.login);
        this.router.post('/empleador/register', this.UserController.registerEmpleador);
        this.router.post('/empleador/solicitud', auth,this.UserController.enviarSolicitudEmpleador);

        this.router.post('/trabajador/register',this.UserController.registerTrabajador);

        this.router.get('/solicitudes',this.UserController.getSolicitudes);
        this.router.get('/documentacion',this.ApiDocument.registerEmpleador);

    
    }

}

export default UserRoute;