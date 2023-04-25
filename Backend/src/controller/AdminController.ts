import { Request, Response } from "express";
import AdminModel from "../model/AdminModel";
import path from 'path'
import * as dotenv from 'dotenv';
dotenv.config();

class UserController {

    private model: AdminModel;

    constructor() {
        this.model = new AdminModel();
    }

    public index = (req: Request, res: Response) => res.json({ 'error': 0, 'msg': 'API: node-express-ts' });


    public insertCategoria = async (req: Request, res: Response) => {
        const {nombre} = req.body;
        this.model.InsertCategoriaTrabajo(nombre,(error:any,rows:any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}  
            return res.json({ error: false, message: 'Ok' }); 
        });

    }

    public deleteCategoria = async (req: Request, res: Response) => {
        const {nombre} = req.params;

        this.model.DeleteCategoriaTrabajo(nombre,(error:any,rows:any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}  
            return res.json({ error: false, message: 'Ok' }); 
        });

    }

    public VistaAdmin = async (req: Request, res: Response) => {
        const archivo = path.join(__dirname + "/../View/admin.html");
        return res.sendFile(archivo);

    }

   




}

export default UserController;