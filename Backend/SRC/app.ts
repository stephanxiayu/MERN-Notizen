import "dotenv/config";
import express, {NextFunction, Request, Response} from "express";
import notesRoutes from "./routes/notes";
import userRoutes from "./routes/user";
import morgan from "morgan";
import createHttpError, {isHttpError} from "http-errors";
import session, { Cookie } from "express-session";
import env from "./util/validateEnv"
import MongoStore from "connect-mongo";
import { requiresAuth } from "./middleware/auth";



const app= express();

app.use(morgan("dev"))

app.use(express.json());

app.use(session({
    secret:env.Session_SECRET,
    resave:false,
    saveUninitialized:false,
    cookie:{
        maxAge:100*1000*1000,
    },rolling:true,
    store:MongoStore.create({
        mongoUrl:env.Mongo_CONNECTION_STRING
    })
}))

app.use("/api/user", userRoutes)

app.use("/api/notes",requiresAuth, notesRoutes);


app.use((req, res, next)=>{
    next(createHttpError(404,"Endpoint nicht gefunden"));
})
// eslint-disable-next-line @typescript-eslint/no-unused-vars
app.use((error:unknown,req:Request, res:Response, next: NextFunction)=>{
    console.error(error);
    let errorMessage ="Alter, was ist bei dir falsch!";
    let statusCode=500;
    if(isHttpError(error)){
        statusCode= error.status
        errorMessage=error.message
    }
    res.status(statusCode).json({error:errorMessage})
})

export default app