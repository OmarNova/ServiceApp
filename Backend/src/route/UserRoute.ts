import { Router } from "express";
import UserController from "../controller/UserController"
import auth from "../middleware/auth";
import multer from "../middleware/multer";

class UserRoute {

    public router: Router;
    private UserController: UserController;

    constructor() {
        this.router = Router();
        this.UserController = new UserController();
        this.config();
    }

    public config = (): void => {
        this.router.get('/', this.UserController.index);
        this.router.post('/user/register', this.UserController.register);
        this.router.post('/user/login', this.UserController.login);

    
    }

}

export default UserRoute;