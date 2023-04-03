

export function formatDate(dateString: string):string{
    return new Date(dateString).toLocaleString("de-DE",
    {    hour:"numeric",
    minute:"numeric",
        day:"numeric",
        month:"short",
        year:"numeric",
       
        
    })
}