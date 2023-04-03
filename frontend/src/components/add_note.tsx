import { Button, Form, Modal } from "react-bootstrap";
import { useForm } from "react-hook-form";
import { Note } from "../models/note";
import { NoteInput } from "../Network/notes_api";
import * as NotesApi from "../Network/notes_api";

interface AddNoteprobs{
    onDismiss: ()=>void
    onNoteSaved:(note:Note[])=>void
}


const AddNoteDialog = ({onDismiss, onNoteSaved}: AddNoteprobs) => {

    const {register, handleSubmit, formState:{errors, isSubmitting}}=useForm<NoteInput>()

    async function onSubmit(input:NoteInput) {
        try {
            const noteResponse=await NotesApi.createNote(input);
          onNoteSaved(noteResponse)
        } catch (error) {
            console.error(error)
            alert(error)
        }
        
    }

    return ( 
        <Modal show onHide={onDismiss}>
<Modal.Header closeButton>
    <Modal.Title>
        Notiz hinzufügen
    </Modal.Title>
</Modal.Header>

<Modal.Body>
    <Form id="addNoteForm" onSubmit={handleSubmit(onSubmit)}>
        <Form.Group className="mb-3">
            <Form.Label>Title</Form.Label>
            <Form.Control
            type="title"
            placeholder="Title"
            isInvalid={!!errors.title}
            {...register("title", {required:"Required"})}
            />
            <Form.Control.Feedback type="invalid">
                {errors.title?.message}
            </Form.Control.Feedback>
        </Form.Group>

<Form.Group className="mb-3">
    <Form.Label>Text</Form.Label>
    <Form.Control
    as="textarea"
    rows={6}
    placeholder="Text"
    {...register("text")}
    />

</Form.Group>

    </Form>
</Modal.Body>
<Modal.Footer >
    <Button
    type="submit"
    form="addNoteForm"
    disabled={isSubmitting}
     variant="secondary" size="lg" active>Speichern</Button>
</Modal.Footer>
        </Modal>
     );
}
 
export default AddNoteDialog;