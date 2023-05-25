import { RequestHandler } from "express";
import createHttpError from "http-errors";
import mongoose from "mongoose";
import NoteModel from "../models/note";
import { assertIsDefined } from "../util/assertIsDefined";

export const getNotes: RequestHandler = async (req, res, next) => {

  const authenticatedUserId = req.session.userId
  try {
   assertIsDefined(authenticatedUserId)

    const notes = await NoteModel.find({userId:authenticatedUserId}).exec();
    res.status(200).json(notes);
  } catch (error) {
    next(error);
  }
};

export const getNote: RequestHandler = async (req, res, next) => {
  const noteId = req.params.noteId;
  const authenticatedUserId = req.session.userId
  try {
    assertIsDefined(authenticatedUserId)
    if (!mongoose.isValidObjectId(noteId)){
        throw createHttpError(400, "keine gültige Notiz ID")
    }
    const note = await NoteModel.findById(noteId).exec();
    if (!note) {
      throw createHttpError(404, "die Notiz nicht gefunden");
    }
    if(!note.userId.equals(authenticatedUserId)){
      throw createHttpError(401,"401 error")
    }

    res.status(200).json(note);
  } catch (error) {
    next(error);
  }
};

interface CreateNoteBody {
  title?: string;
  text?: string;
}

export const createNote: RequestHandler<
  unknown,
  unknown,
  CreateNoteBody,
  unknown
> = async (req, res, next) => {
  const { title, text } = req.body;
  const authenticatedUserId = req.session.userId

  try {
    assertIsDefined(authenticatedUserId)
    if (!title) {
      throw createHttpError(400, "die Notiz benötigt einen Title");
    }

    const newNote = await NoteModel.create({
      userId:authenticatedUserId,
      title,
      text,
    });

    res.status(201).json(newNote);
  } catch (error) {
    next(error);
  }
};

interface UpdateNoteParams{
    noteId:string
}

interface UpdateNoteBody {
    title?: string;
    text?: string;
  }
export const updateNote: RequestHandler<UpdateNoteParams, unknown, UpdateNoteBody, unknown> =async (req, res, next) => {
    const noteId=req.params.noteId
    const newTitle=req.body.title
    const newText=req.body.text
    const authenticatedUserId = req.session.userId
    try {
      assertIsDefined(authenticatedUserId)
        if (!mongoose.isValidObjectId(noteId)){
            throw createHttpError(400, "keine gültige Notiz ID")
        }
        if (!newTitle) {
            throw createHttpError(400, "die Notiz benötigt einen Title");
          }
          const note=await NoteModel.findById(noteId).exec()
          if (!note) {
            throw createHttpError(404, "die Notiz nicht gefunden");
          }
        if(!note.userId.equals(authenticatedUserId)){
          throw createHttpError(404,"404")
        }
          note.title=newTitle
          note.text=newText
          const updatedNote =await note.save()

          res.status(200).json(updatedNote)
    } catch (error) {
        next(error);
    }
}

export const deleteNote: RequestHandler=async(req, res, next)=>{
    const noteId=req.params.noteId
    const authenticatedUserId = req.session.userId
    try {
      assertIsDefined(authenticatedUserId)
        if (!mongoose.isValidObjectId(noteId)){
            throw createHttpError(400, "keine gültige Notiz ID")
        }

        const note=await NoteModel.findById(noteId).exec()
        if(!note){
            throw createHttpError(404, "Notitz nicht gefunden")

        }
        if(!note.userId.equals(authenticatedUserId)){
          throw createHttpError(404,"404")
        }

        await NoteModel.findByIdAndRemove(noteId).exec()
        res.sendStatus(204)
    } catch (error) {
        next(error);
    }
}