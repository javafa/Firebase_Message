<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.util.*, java.security.*, java.io.*, java.net.*" %>
<%
	// 요청값에 대한 한글처리
	request.setCharacterEncoding("UTF-8");

	StringBuffer result = new StringBuffer();

	// 메시지를 실제 전송해주는 파이어베이스 서버 주소
	String fcmServer = "https://fcm.googleapis.com/fcm/send";
	// 우리가 생성한 프로젝트의 서버키 - 각 앱의 클라우드메시징 탭에 있음
	String myServerkey = "AIzaSyAzgfDGRPlydgPKDqS7P6s7l6X25mJ6xno";
	String title = request.getParameter("title");
	String msg = request.getParameter("msg");
	String toDevice = "dQQcjcaFn48:APA91bGUi3pd76yKI-fMHcPz1fXA1Yly2Ow-gpxmQiFi95gX1ToYM6pTUd4bd86wS1wHe8cAyUtq2sm1wxCm0fVTSReEkKtPl5ut9ZOWFo1Xn6D8UqDGXBqZ3SkomPYvUw7ONA4aIoXF";

    URL url = new URL(fcmServer);
    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    connection.setRequestMethod("POST");
    connection.setRequestProperty("Authorization","key="+myServerkey);
    connection.setRequestProperty("Content-Type","application/json");

	String jsonData = "{\"to\":\"" + toDevice + "\",\"notification\":{\"title\":\""+title+"\",\"body\":\""+msg+"\"}}";

    // post 처리일 경우만 ------------
    connection.setDoOutput(true);
    OutputStream os = connection.getOutputStream();
    os.write(jsonData.getBytes());
    os.flush();
    os.close();
    // -------------------------------
    // 결과 코드 담기
    int responseCode = connection.getResponseCode();
    //: 200 번은 성공
    if(responseCode == HttpURLConnection.HTTP_OK){
        // 성공했을 경우 서버에서 리턴해주는 데이터를 buffer 에 담은후에
        BufferedReader br = new BufferedReader(new InputStreamReader( connection.getInputStream() ) );
        String dataLine = null;
        // 한줄씩 읽어서 처리한다
        while( (dataLine = br.readLine()) != null){
            result.append(dataLine);
        }
        br.close();
        // 그외의 코드는 실패이므로 실패처리 코드를 로그에 찍어준다
    }else{
        out.print("HTTP error code="+responseCode);
    }

    out.print(result.toString());

%>
