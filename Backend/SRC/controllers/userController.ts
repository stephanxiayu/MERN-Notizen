import { RequestHandler } from "express";
import createHttpError from "http-errors";
import UserModel from "../models/user";
import bcrypt from "bcrypt";

interface SignUpBody{
    username?:string,
    email?:string,
    password?:string
}

export const signUp: RequestHandler<unknown, unknown, SignUpBody,unknown>=async(req,res, next)=>{
const username =req.body.username;
const email=req.body.email;
const passwordRaw=req.body.password;

try {
    
    if(!username||!email||!passwordRaw){
        throw createHttpError(400, "Email oder Password oder der Username fehlt")
    }

    const existingUsername=await UserModel.findOne({
        username:username
    }).exec()
  

    if (existingUsername){
        throw createHttpError(409, "Username already exist, please take an other one ");
        
    }
    const existingEmaile=await UserModel.findOne({
        email:email
    }).exec()
    if (existingEmaile){
        throw createHttpError(409, "Email already exist, please login ");
        
    }


const passwordHashed= await bcrypt.hash(passwordRaw, 10)

const newUser=await UserModel.create({
    username:username,
    email:email,
    password:passwordHashed
})

req.session.userId=newUser._id;


res.status(201).json(newUser)
} catch (error) {
    next(error)
}
};

interface LoginBody{
    username?:string,
    password?:string
}

export const login:RequestHandler<unknown,unknown, LoginBody, unknown>=async(req,res, next)=>{
    const username=req.body.username;
    const password=req.body.password

    try {
        if(!username||!password){
            throw createHttpError(400, "Username oder Password fehlt...")
        }

        const user=await UserModel.find({
            username:username
        }).select("+password +email").exec()
            if(!user){
               throw createHttpError(401, "Invalide Login Creadentials") 
            }
    } catch (error) {
        next(error)
    }
}