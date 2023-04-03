import app from "./app";
import env from "./util/validateEnv";
import mongoose from "mongoose";




const port=env.PORT


mongoose.connect(env.Mongo_CONNECTION_STRING)
.then(()=>{console.log("Mongo DataBase is init");
app.listen(port,()=>{
    console.log("Server running on Prt:"+port);
})}).catch(console.error)

