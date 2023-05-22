import { useForm } from "react-hook-form"
import { User } from "../../models/user"
import { LoginCredentials } from "../../Network/notes_api"
import *as NotesApi from "../../Network/notes_api"
import { Button, Form, Modal } from "react-bootstrap"
import TextInputField from "./textinputfield"
import styles from "../../styles/NotesPage.module.css";
interface LoginModalProps{
    onDismiss:()=>void,
    onLonginSuccessful:(user:User)=>void
}

const LoginModal=({onDismiss, onLonginSuccessful}: LoginModalProps)=>{

    const {register, handleSubmit,formState:{errors, isSubmitting} } =useForm<LoginCredentials>()
async function onSubmit(credentials:LoginCredentials) {
    try {
        const user=await NotesApi.login(credentials)
        onLonginSuccessful(user)
    } catch (error) {
        alert(error)
        console.error(error)
    }
    
}
    return (
        <Modal show onHide={onDismiss}>
        <Modal.Header closeButton>
            <Modal.Title>
            Login
            </Modal.Title>
           
        </Modal.Header>
            <Modal.Body>
                <Form onSubmit={handleSubmit(onSubmit)}>
                    <TextInputField
                    name="username"
                    label="Username"
                    type="text"
                    placeholder="Username"
                    register={register}
                    registerOption={{required:"Required"}}
                    error={errors.username}
                    
                    />
                     
                  
                    
                    <TextInputField
                    name="password"
                    label="Password"
                    type="password"
                    placeholder="Password"
                    register={register}
                    registerOption={{required:"Required"}}
                    error={errors.password}
                    
                    />
<Button
type="submit"
disabled={isSubmitting}
className={`${styles.with100} ${styles.buttonGradient}`}
>
Einloggen 
</Button>
                   
                </Form>
            </Modal.Body>

</Modal>
    )

}

export default LoginModal