

class HttpError extends Error{
    constructor(message?:string){
        super(message)
        this.name=this.constructor.name
    }
}
/**
 StatusCode 401
 */
export class UnauthorizedError extends HttpError {

}
/**
 StatusCode 409
 */
export class ConflictError extends HttpError {

}