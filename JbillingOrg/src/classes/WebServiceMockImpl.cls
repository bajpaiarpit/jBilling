@isTest
global class WebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
   /*    docSample.EchoStringResponse_element respElement = 
           new docSample.EchoStringResponse_element();
       respElement.EchoStringResult = 'Mock response';
       response.put('response_x', respElement); */
       Type t = Type.forName(responseType);
       response.put('response_x',  t.newInstance()  );
       system.debug('type: '+t);
       system.assertequals(string.valueOf(t),responseType);
         
   }
}