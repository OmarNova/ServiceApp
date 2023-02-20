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

    public register = async (req: Request, res: Response) => {
        const { nombres, email, passwd, apellidos, telefono } = req.body;
        const password_hash=bcrypt.hashSync(passwd, 10);
        this.model.getUser(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}   
            if (rows.length == 0) {
                this.model.InsertUser(nombres,apellidos,email,telefono,password_hash, (error: any, rows: any) => {
                    if (error) {console.error(error);return { error: true, message: 'error database' };}
                    return res.json({ error: false, message: "Ok"});
                });
            } else {
                return res.json({ error: true, message: 'User Already Exists' });
            }
        });
    }

    public login = async (req: Request, res: Response) => {
        const { email, passwd  } = req.body;
  
        this.model.getUser(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}   
        
            if (rows.length != 0) {
                const verified = bcrypt.compareSync(passwd, rows[0].passwd);
                if(!verified) {
                    return res.json({error: true, message: "Contraseña Incorrecta!"});
                }
                const token = jwt.sign({email: email}, process.env.key as string);   
                return res.json({error: false, message: "Ok", token: token});

            } else {
                return res.json({ error: true, message: 'User not Found' });
            }
        });
    }

   





}

export default UserController;