import { Request, Response } from "express";
import path from 'path'
import fs from 'fs'

import * as dotenv from 'dotenv';
dotenv.config();

class ApiDocumentController {


    constructor() {
      
    }

    public registerEmpleador =  (req: Request, res: Response) => {
        const archivo = path.join(__dirname + "/../ApiDocument/index.html");
        return res.sendFile(archivo);
        //res.json({message:"ok"});
        
    }
    

}

export default ApiDocumentController;