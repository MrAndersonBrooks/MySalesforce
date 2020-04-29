@isTest
public class ProjectCalloutServiceMockFailure implements HttpCallOutMock {
    public HttpResponse respond(HttpRequest reqesut){
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('error');
        res.setStatusCode(500);
        
        return res;
    } 
}