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

    public index = (req: Request, res: Response) =>{ 
        res.json({ 'error': 0, 'msg': 'API: node-express-ts' })};

    public registerEmpleador = async (req: Request, res: Response) => {
        const { nombres, email, passwd, apellidos, telefono, direccion } = req.body;
        const password_hash=bcrypt.hashSync(passwd, 10);
        this.model.getEmpleador(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}   
            if (rows.length == 0) {
                this.model.InsertEmpleador(nombres,apellidos,email,telefono,password_hash,direccion, (error: any, rows: any) => {
                    if (error) {console.error(error);return { error: true, message: 'error database' };}
                    return res.json({ error: false, message: "Ok"});
                });
            } else {
                return res.json({ error: true, message: 'User Already Exists' });
            }
        });
    }

    public registerTrabajador = async (req: Request, res: Response) => {
        const { email, trabajo, descripcion, categoria , direccion } = req.body;

        this.model.getEmpleador(email, (error: any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}  

            if (rows.length != 0) {

                this.model.getIdCategoriasTrabajos(categoria, (err: any, row: any) => {
                    if (err) {console.error(err);return { error: true, message: 'error database' };}

                    this.model.InsertTrabajador(rows[0].nombres,rows[0].apellidos,rows[0].email, rows[0].telefono,trabajo, descripcion, row[0].idcategorias, direccion,(e: any, respuesta: any) => {
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


    public getCategorias = async (req: Request, res: Response) => {

        this.model.getCategorias((error:any, rows: any) => {
            let categorias = []
            if (error) {console.error(error);return { error: true, message: 'error database' };}
            for (let index = 0; index < rows.length; index++) {
                categorias.push(rows[index]['nombres']);
                
            }


            return res.json({error: false, message: "Ok", categorias: categorias});
        });
    }

    public enviarSolicitudEmpleador = async (req: Request, res: Response) => {
        const { email, titulo, descripcion, categoria ,direccion } = req.body;
        
        this.model.getEmpleador(email.email, (error: any, rows: any) => {
            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });}   
        
            if (rows.length != 0) {

                this.model.getIdCategoriasTrabajos(categoria,(err: any, row: any)=> {
                    this.model.postSolicitudEmpleador(rows[0].idempleador,titulo,descripcion,row[0].idcategorias,direccion,(err:any,row:any) => {
                        if (err) {console.error(err);return { error: true, message: 'error database' };}
                       
                        return res.json({error: false, message: "Ok"});
                    });
                });


            } else {
                return res.status(410).json({ error: true, message: 'User not Found' });
            }
        });
    }

    public getSolicitudesPorCategoria = async (req: Request, res: Response) => {
        const {categoria} = req.params;

        this.model.getSolicitudesPorCategoria(categoria,(error:any, rows: any) => {
            if (error) {console.error(error);return { error: true, message: 'error database' };}  
            return res.json({error: false, message: "Ok", solicitudes: rows});
        });
    }


    public getSolicitudesPostulantes = async (req:Request, res: Response) => {
        const { email} = req.body;
        let idSolicitud = parseInt(req.params['idSolicitud']);
        if (!Number.isNaN(idSolicitud)) {

            this.model.getEmpleador(email.email,(error:any,rows:any)=> {

                if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });} 
    
                if (rows.length != 0) {
                    this.model.verificarEmpleadorSolicitud(idSolicitud,(err:any,row:any)=>{
    
                        if (err) {console.error(err);return res.status(405).json({ error: true, message: 'error database' });}  
                        
                        if (row.length != 0) {
                            if (rows[0].idempleador == row[0].empleador_idempleador) {
        
                                this.model.getPostulantesSolicitud(idSolicitud,(e:any,r:any)=>{
                                    if (e) {console.error(e);return res.status(405).json({ error: true, message: 'error database' });}
                                    return res.json({error: false, message: "Ok", postulantes:r}); 
                                });
                            } else{
                                return res.json({error: true, message: "Autorización Fallida"}); 
                            }
                        } else {
                            return res.json({error: true, message: "No hay solicitud con ese ID"}); 
                        }
    
                        
                    });
                } else{
                    return res.json({error: true, message: "Usuario no encontrado"}); 
                }
            });
        } else {
            return res.json({error: true, message: "Id error"}); 
        }

        

    }

    public solicitudTrabajadorPostularse = async (req:Request, res: Response) => {
        const { email, idSolicitud } = req.body;
        this.model.getTrabajador(email.email,(error:any,rows:any)=> {
            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });} 
            
            if (rows.length != 0) {

                this.model.postSolicitudTrabajadorPostularse(idSolicitud,rows[0].idtrabajador,(err:any,row:any)=>{
                    if (err) {console.error(err);return { error: true, message: 'error database' };}
                    return res.json({error: false, message: "Ok"}); 
                });

                
            } else {
                return res.status(410).json({ error: true, message: 'User not Found' });
            }
        
        });
    }

    public getTrabajadores = async (req: Request, res: Response) => {
    
        this.model.getTrabajadores((error:any,rows:any)=>{
            if (error) {console.error(error);return { error: true, message: 'error database' };} 
            return res.json({error: false, message: "Ok", trabajadores: rows});  
        });
    }

    public getTrabajadoresPorCategoria = async (req: Request, res: Response) => {
        const {categoria} = req.params;

        this.model.getTrabajadoresPorCategoria(categoria,(error:any,rows:any)=>{
            if (error) {console.error(error);return { error: true, message: 'error database' };} 
            return res.json({error: false, message: "Ok", trabajadores: rows});  
        });
    }

    public AceptarTrabajador = async (req: Request, res: Response) => {
        const {email,idSolicitud,idTrabajador} = req.body;

        this.model.getEmpleador(email.email,(error:any,rows:any)=> {

            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });} 

            if (rows.length != 0) {
                this.model.verificarEmpleadorSolicitud(idSolicitud,(err:any,row:any)=>{

                    if (err) {console.error(err);return res.status(405).json({ error: true, message: 'error database' });}  
                    
                    if (row.length != 0) {
                        if (rows[0].idempleador == row[0].empleador_idempleador) {
    
                            this.model.AceptarTrabajador(idTrabajador,idSolicitud,(error:any,rows:any)=>{
                                if (error) {console.error(error);return { error: true, message: 'error database' };} 
                                return res.json({error: false, message: "Ok"});  
                            });
                        } else{
                            return res.json({error: true, message: "Autorización Fallida"}); 
                        }
                    } else {
                        return res.json({error: true, message: "No hay solicitud con ese ID"}); 
                    }

                    
                });
            } else{
                return res.json({error: true, message: "Usuario no encontrado"}); 
            }
        });

        
    }

    public getMisSolicitudes = async (req: Request, res: Response) => {
        const {email} = req.body;

        this.model.getEmpleador(email.email,(error:any,rows:any)=> {

            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });} 

            if (rows.length != 0) {
                this.model.getMisSolicitudesEmpleador(rows[0].idempleador,(err:any,row:any)=> {
                    if (err) {console.error(err);return res.status(405).json({ error: true, message: 'error database' });}
                    return res.json({error: false, message: "Ok", solicitudes: row}); 
                });
            } else{
                return res.json({error: true, message: "Usuario no encontrado"}); 
            }
        });
    }

    public subirImagen = async (req: Request, res: Response) => {
        const { email, img } = req.body;
        const binaryData = Buffer.from(img, 'base64');

        this.model.getEmpleador(email.email, (error: any, rows: any) => {
            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });}   
        
            if (rows.length != 0) {

                this.model.subirImagen(binaryData,rows[0].idempleador,(err:any,row:any)=>{
                    if (err) {console.error(err);return { error: true, message: 'error database' };}
                    return res.json({error: false,message: "Ok"});
                });

         
            } else {
                return res.status(410).json({ error: true, message: 'User not Found' });
            }
        });
    }

    public getImagen = async (req: Request, res: Response) => {
        const { email } = req.body;
       
        this.model.getEmpleador(email.email, (error: any, rows: any) => {
            if (error) {console.error(error);return res.status(405).json({ error: true, message: 'error database' });}   
            console.log(rows);
            if (rows.length != 0) {

                this.model.getImagen(rows[0].idempleador,(err:any,row:any)=>{
                    console.log(row[0].image);
                    if (row[0].image) {
                        res.write(row[0].image,'binary');
                        res.end(null, 'binary');
                    } else{
                        return res.status(401).json({ error: true, message: 'Not image' });
                    }
                });

         
            } else {
                return res.status(410).json({ error: true, message: 'User not Found' });
            }
        });
    }

}

export default UserController;