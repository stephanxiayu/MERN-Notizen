import { Button, Navbar } from "react-bootstrap"
import { User } from "../models/user"
import * as NotesApi from "../Network/notes_api"
import styles from "../styles/NotesPage.module.css";

interface NavBarLoggedInviewProps{
    user:User
    onLogoutSuccessful:()=>void
}

const NavBarLoggedInview=({user, onLogoutSuccessful}:NavBarLoggedInviewProps)=>{
    async function logout() {
        try {
            await NotesApi.logout()
            onLogoutSuccessful()
        } catch (error) {
           console.error(error) 
           alert(error)
        }
    }
    
    
    return (
           <>
          <Navbar.Text className="me-2" style={{ color: 'black' }}>
    Eingeloggt als: {user.username}
</Navbar.Text>
<Button onClick={logout} style={{ backgroundColor: 'white',border:'none', color: 'black' }}>
    Ausloggen
</Button>

           
           </> 

    )

}

export default NavBarLoggedInview