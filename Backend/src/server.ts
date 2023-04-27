import express, { Application, json, urlencoded } from "express";
import UserRoute from "./route/UserRoute";
import AdminRoute from "./route/AdminRoute";
import cors from 'cors';
import https from 'https';


class Server {

    private backend: Application;
    private userRoute: UserRoute;
    private adminRoute: AdminRoute;
    private https: any;

    constructor() {
        this.https = https;
        this.backend = express();
        this.userRoute = new UserRoute();
        this.adminRoute = new AdminRoute();
        this.config();
        this.route();
        this.start();
    }

    public config = (): void => {
        this.backend.set('port', 80);
        this.backend.use(urlencoded({extended: true}));
        this.backend.use(json());
        this.backend.use(cors());
        
    }

    public route = (): void => {
        this.backend.use('/api', this.userRoute.router);
        this.backend.use('/api/admin', this.adminRoute.router);
    }

    public start = (): void => {/*
        this.https.createServer({
            key: fs.readFileSync("private.key"),
            cert: fs.readFileSync("certificate.crt")
          }
          ,this.backend).listen(this.backend.get('port'), () => {
            console.log('Server on port:', this.backend.get('port'));
        });*/
        
        this.backend.listen(this.backend.get('port'), () => {
            console.log('Server on port:', this.backend.get('port'));
        });
    }

}


const server = new Server();