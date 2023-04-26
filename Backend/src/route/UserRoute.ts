import { Router } from "express";
import UserController from "../controller/UserController"
import auth from "../middleware/auth";
import auth_imagen from "../middleware/auth_image";
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
        this.router.put('/empleador/aceptarTrabajador',auth,this.UserController.AceptarTrabajador);
        this.router.get('/empleador/propuestas/:idSolicitud',auth,this.UserController.getSolicitudesPostulantes);
        this.router.get('/empleador/solicitudes', auth,this.UserController.getMisSolicitudes);
        this.router.post('/empleador/imagen/perfil', auth,this.UserController.subirImagen);
        this.router.get('/empleador/imagen/perfil', auth_imagen,this.UserController.getImagen);
        //this.router.post('/empleador/solicitud/terminada', auth,this.UserController.getMisSolicitudes);

        this.router.post('/trabajador/register',this.UserController.registerTrabajador);
        this.router.post('/trabajador/postularse',auth,this.UserController.solicitudTrabajadorPostularse);
        this.router.get('/trabajadores',this.UserController.getTrabajadores);
        this.router.get('/trabajadores/buscar/:categoria',this.UserController.getTrabajadoresPorCategoria);
        //this.router.post('/trabajadores/trabajo/finalizado',this.UserController.getTrabajadoresPorCategoria);

        this.router.get('/solicitudes',this.UserController.getSolicitudes);
        this.router.get('/solicitudes/:categoria',this.UserController.getSolicitudesPorCategoria);
        this.router.get('/categorias',this.UserController.getCategorias);

        this.router.get('/documentacion',this.ApiDocument.registerEmpleador);

    
    }

}

export default UserRoute;