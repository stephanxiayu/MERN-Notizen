import { useForm } from "react-hook-form"
import { User } from "../../models/user"
import { SignUpCredentials } from "../../Network/notes_api"
import *as NotesApi from "../../Network/notes_api"
import { Button, Form, Modal } from "react-bootstrap"
import TextInputField from "./textinputfield"
import styles from "../../styles/NotesPage.module.css";

interface SignUpModelProps{
    onDismiss:()=>void
    onSignUpSuccessful:(user:User)=>void
}

const SignUpModel=({onDismiss,onSignUpSuccessful}:SignUpModelProps)=>{

    const {register,handleSubmit, formState:{errors,isSubmitting} }=useForm<SignUpCredentials>()
    async function onSubmit(credentials:SignUpCredentials) {
        try {
            const newUser=await NotesApi.signUp(credentials)
            onSignUpSuccessful(newUser)
        } catch (error) {
            alert(error)
            console.error(error)
        }
        
    }
    return(
        <Modal show onHide={onDismiss}>
                <Modal.Header closeButton>
                    <Modal.Title>
                    kostenloses Konto erstellen
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
                            name="email"
                            label="Email"
                            type="email"
                            placeholder="Email"
                            register={register}
                            registerOption={{required:"Required"}}
                            error={errors.email}
                            
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
  Konto erstellen
</Button>
                           
                        </Form>
                    </Modal.Body>

        </Modal>
    )
}

export default SignUpModel