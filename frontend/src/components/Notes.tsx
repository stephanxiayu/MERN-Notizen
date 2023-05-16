import stlyes from "../styles/Note.module.css";
import { Card } from "react-bootstrap"
import { Note as NoteModel } from "../models/note"
import { formatDate } from "../Utils/formatDate";
import {MdDelete} from "react-icons/md";


interface NoteProps{
    onNoteClicked:(note: NoteModel)=>void
    note:NoteModel, 
    className?:string
    onDeleteNoteClick:(note:NoteModel)=>void
}

const Note=({note,onNoteClicked,onDeleteNoteClick, className}:NoteProps)=>{

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
    <Card
     className={`${stlyes.noteCard} ${className}`}
     onClick={()=>onNoteClicked(note)}
     >
        <Card.Body className={stlyes.cardBody}>
            <Card.Title className={stlyes.cardText}>
                {title}
            
            </Card.Title>
            <Card.Text className={stlyes.cardText}>
                {text}
            </Card.Text>
            
        </Card.Body>
        <Card.Footer className="d-flex text-muted">
    {createdUpdatedText}
    <div className="ms-auto">
        <MdDelete 
            className="text-muted"
            onClick={(e) => {
                onDeleteNoteClick(note);
                e.stopPropagation();
            }}
        />
    </div>
</Card.Footer>

    </Card>
)
}

export default Note