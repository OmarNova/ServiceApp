import { Request, Response, NextFunction } from "express";
import  jwt from "jsonwebtoken";
import * as dotenv from 'dotenv';
dotenv.config();

export default async function verifyToken (req: Request, res: Response, next: NextFunction)  {
    const token = req.headers['authorization'];
    if(!token){
        return res.status(403).json({error: true, message: "No Token Provided"});
    }

    jwt.verify(token,process.env.key as string, function(err, decoded) {
        if (err) { return res.status(403).json({error: true, message: err.message});}
        const t = JSON.parse(JSON.stringify(decoded))
        req.body.email = t;
        next();
      });

}