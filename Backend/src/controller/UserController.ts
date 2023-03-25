import { Request, Response } from "express";
import UserModel from "../model/UserModel";
import bcrypt from "bcrypt";
import path from 'path'
import fs from 'fs'
import jwt from "jsonwebtoken";
import * as dotenv from 'dotenv';
dotenv.config();

class UserController {

    private model: UserModel;

    constructor() {
        this.model = new UserModel();
    }

    public index = (req: Request, res: Response) => res.json({ 'error': 0, 'msg': 'API: node-express-ts' });

    public registerEmpleador = async (req: Request, res: Response) => {
        const { nombres, email, passwd, apellidos, telefono } = req.body;
        const password_hash=bcrypt.hashSync(passwd, 10);
        this.model.getEmpleador(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}   
            if (rows.length == 0) {
                this.model.InsertEmpleador(nombres,apellidos,email,telefono,password_hash, (error: any, rows: any) => {
                    if (error) {console.error(error);return { error: true, message: 'error database' };}
                    return res.json({ error: false, message: "Ok"});
                });
            } else {
                return res.json({ error: true, message: 'User Already Exists' });
            }
        });
    }

    public registerTrabajador = async (req: Request, res: Response) => {
        const { email, trabajo, descripcion, categoria } = req.body;

        this.model.getEmpleador(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}  

            if (rows.length != 0) {

                this.model.getCategoriasTrabajos(categoria, (err: any, row: any) => {
                    if (err) {console.error(err);return { error: true, message: 'error database' };}

                    this.model.InsertTrabajador(rows[0].nombres,rows[0].apellidos,rows[0].email, rows[0].telefono,trabajo, descripcion, row[0].idcategorias, (e: any, respuesta: any) => {
                        if (e) {console.error(e);return { error: true, message: 'error database' };}   
                        return res.json({ error: false, message: "Ok"});
                    });

                });
            } else {
                return res.json({ error: true, message: 'User Not Exists' });
            }
        });
    }

    public login = async (req: Request, res: Response) => {
        const { email, passwd  } = req.body;
  
        this.model.getEmpleador(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}   
        
            if (rows.length != 0) {
                const verified = bcrypt.compareSync(passwd, rows[0].passwd);
                if(!verified) {
                    return res.json({error: true, message: "Contraseña Incorrecta!"});
                }
                
                const token = jwt.sign({email: email}, process.env.key as string, {expiresIn: 604800000} );

                return res.json({error: false, message: "Ok", token: token});

            } else {
                return res.status(410).json({ error: true, message: 'User not Found' });
            }
        });
    }


    public getSolicitudes = async (req: Request, res: Response) => {

        this.model.getSolicitudes((error:any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}  
            return res.json({error: false, message: "Ok", solicitudes: rows});
        });
    }

    public enviarSolicitudEmpleador = async (req: Request, res: Response) => {
        const { email, titulo, descripcion  } = req.body;
        this.model.getEmpleador(email, (error: any, rows: any) => {
            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });}   
        
            if (rows.length != 0) {
                this.model.postSolicitudEmpleador(rows[0].idempleador,titulo,descripcion,(err:any,row:any) => {
                    if (error) {console.error(error);return { error: true, message: 'error database' };}
                   
                    return res.json({error: false, message: "Ok"});
                });
            } else {
                return res.status(410).json({ error: true, message: 'User not Found' });
            }
        });
    }

   




}

export default UserController;