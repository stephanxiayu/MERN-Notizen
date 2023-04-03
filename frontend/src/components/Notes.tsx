import stlyes from "../styles/Note.module.css";
import { Card } from "react-bootstrap"
import { Note as NoteModel } from "../models/note"
import { formatDate } from "../Utils/formatDate";
import {MdDelete} from "react-icons/md";


interface NoteProps{
    note:NoteModel, 
    className?:string
    onDeleteNoteClick:(note:NoteModel)=>void
}

const Note=({note,onDeleteNoteClick, className}:NoteProps)=>{

    const {title,
    text,
    createdAt,
updatedAt
}=note

let createdUpdatedText: string;
if (updatedAt>createdAt){
    createdUpdatedText="geändert: "+formatDate(updatedAt)
}else{
    createdUpdatedText=" erstellt am: "+formatDate(createdAt)
}

return (
    <Card className={`${stlyes.noteCard} ${className}`}>
        <Card.Body className={stlyes.cardBody}>
            <Card.Title className={stlyes.flexCenter}>
                {title}
                <MdDelete 
                className="text-muted ms-auto"
                onClick={(e)=>{
                    onDeleteNoteClick(note)
                        e.stopPropagation()
                }}
                >

                </MdDelete>
            </Card.Title>
            <Card.Text className={stlyes.cardText}>
                {text}
            </Card.Text>
            
        </Card.Body>
        <Card.Footer className="text-muted">
                {createdUpdatedText}
            </Card.Footer>
    </Card>
)
}

export default Note