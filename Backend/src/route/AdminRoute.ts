import { Router } from "express";
import AdminController from "../controller/AdminController"
import ApiDocument from "../controller/ApiDocumentController"

class UserRoute {

    public router: Router;
    private AdminController: AdminController;

    constructor() {
        this.router = Router();
        this.AdminController = new AdminController();
        this.config();
    }

    public config = (): void => {
        this.router.get('/', this.AdminController.index);
        this.router.post('/trabajo/categoria', this.AdminController.insertCategoria);
        this.router.delete('/trabajo/categoria/:nombre', this.AdminController.deleteCategoria);
        this.router.get('/panel', this.AdminController.VistaAdmin);
      

    }

}

export default UserRoute;