@isTest
public class ProjectCalloutServiceMock  implements HttpCallOutMock {
    public HttpResponse respond(HttpRequest reqesut){
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(201);
        
        return res;
    }
    
    
}