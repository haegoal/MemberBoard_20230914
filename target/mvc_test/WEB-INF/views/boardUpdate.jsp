<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Title</title>
  <link rel="stylesheet" href="/resources/css/bootstrap.min.css">
  <link rel="stylesheet" href="/resources/css/style2.css">
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
          crossorigin="anonymous"></script>
</head>
<body>
<div class="container">
  <div class="row">
    <jsp:include page="header.jsp"></jsp:include>
  </div>
  <h2 class="mt-5 ms-5" style="color: #333D77; font-weight:900;">Member Board &copy;</h2>
  <form class="card p-3" action="/board/update" method="post" enctype="multipart/form-data" name="frm">
    <div class="row m-5">
      <div class="col">
        <c:choose>
          <c:when test="${user!=null}">
            <input class="mt-3" type="hidden" name="boardId" value="${userId}" readonly><br>
            <input class="mt-3" type="text" name="boardWriter" value="${user}" readonly><br>
          </c:when>
          <c:otherwise>
            <input class="mt-3" type="text" name="boardWriter" value=${board.boardWriter} placeholder="글작성자" readonly>
          </c:otherwise>
        </c:choose>
        <input class="mt-3 mb-1" type="text" name="boardTitle" value='${board.boardTitle}' placeholder="제목을 입력해주세요."><br>
        <h6> 쉬운 비밀번호를 입력하면 타인의 수정, 삭제가 쉽습니다. </h6>
        <span class="mb-5"> 음란물, 차별, 비하, 혐오 및 초상권, 저작권 침해 게시물은 민, 형사상의 책임을 질 수 있습니다.    </span><span onclick="policy_fn()" style="font-weight:900; cursor: pointer ">[저작권법 안내]</span>
        <br><br><br>
        <div class="col-md-12">
          <div contentEditable="true" class="form-control">
            <c:if test="${board.fileAttached == 1}">
              <c:forEach items="${boardFileList}" var="boardFile"  varStatus="status">
                <c:if test="${status.index==0}">
                  ${status.index=5}
                </c:if>
                <c:if test="${status.index == 0}">
                <img src="${pageContext.request.contextPath}/upload/${boardFile.storedFileName}" id="image">
                </c:if>
                <c:if test="${status.index == 1}">
                  <img src="${pageContext.request.contextPath}/upload/${boardFile.storedFileName}" id="image1">
                </c:if>
                <c:if test="${status.index == 2}">
                  <img src="${pageContext.request.contextPath}/upload/${boardFile.storedFileName}" id="image2">
                </c:if>
                <c:if test="${status.index == 3}">
                  <img src="${pageContext.request.contextPath}/upload/${boardFile.storedFileName}" id="image3">
                </c:if>
                <c:if test="${status.index == 4}">
                  <img src="${pageContext.request.contextPath}/upload/${boardFile.storedFileName}" id="image4">
                </c:if>
              </c:forEach>
            </c:if>
            <textarea class="form-control" rows="8" cols="100" name="boardContents" value=${board.boardContents} >
                </textarea>
          </div>
        </div>
        <input class="mt-2" type="file" id="file" name="boardFile" multiple accept="image/*" ><br>
        <div class="text-end">
          <input type="submit" value="등록" class="btn btn-primary mt-3">
        </div>
      </div>
    </div>
  </form>
</div>
<div class="modal fade" id="policy_modal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel" style="color: #333D77; font-weight:900;">저작권법 안내</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        이용자가 불법복제물을 게재, 유통하면 이에 대한 경고 및 불법복제물의 삭제 또는 전송 중단 조치를 할 수 있으며, 경고를 받은 이용자에게 사용 정지를 할 수 있습니다.(관련 법률: 저작권법 제133조 의 제1항 및 제2항)
      </div>
    </div>
  </div>
</div>
</div>
</body>
<script>

  $(frm).on("submit", function(e){
    e.preventDefault();
    const boardWriter = $(frm.boardWriter).val();
    const boardTitle = $(frm.boardTitle).val();
    const boardFile = document.getElementById('file');
    if(boardWriter==""){
      alert("작성자 입력바람!")
    }else if(boardTitle == ""){
      alert("제목입력바람")
    }else if(boardFile.length > 5){
      alert("파일은 5개까지만 가능합니다.")
    }else{
      frm.submit();
    }
  })


  $(frm.boardFile).on("change", function (e){
    e.target.files.length=0;
    console.log(e.target.files)
    console.log(e.target.files.length)
    if(e.target.files.length>5) {
      alert("파일은 5개만 업로드됩니다.")
    }else if(e.target.files.length==1) {
      $("#image").attr("src", URL.createObjectURL(e.target.files[0]));
      $("#image1").attr("src", "");
      $("#image2").attr("src", "");
      $("#image3").attr("src", "");
      $("#image4").attr("src", "");
    }else if(e.target.files.length==2) {
      $("#image").attr("src", URL.createObjectURL(e.target.files[0]));
      $("#image1").attr("src", URL.createObjectURL(e.target.files[1]));
      $("#image2").attr("src", "");
      $("#image3").attr("src", "");
      $("#image4").attr("src", "");
    }else if(e.target.files.length==3) {
      $("#image").attr("src", URL.createObjectURL(e.target.files[0]));
      $("#image1").attr("src", URL.createObjectURL(e.target.files[1]));
      $("#image2").attr("src", URL.createObjectURL(e.target.files[2]));
      $("#image3").attr("src", "");
      $("#image4").attr("src", "");
    }else if(e.target.files.length==4) {
      $("#image").attr("src", URL.createObjectURL(e.target.files[0]));
      $("#image1").attr("src", URL.createObjectURL(e.target.files[1]));
      $("#image2").attr("src", URL.createObjectURL(e.target.files[2]));
      $("#image3").attr("src", URL.createObjectURL(e.target.files[3]));
      $("#image4").attr("src", "");
    }else if(e.target.files.length==5) {
      $("#image").attr("src", URL.createObjectURL(e.target.files[0]));
      $("#image1").attr("src", URL.createObjectURL(e.target.files[1]));
      $("#image2").attr("src", URL.createObjectURL(e.target.files[2]));
      $("#image3").attr("src", URL.createObjectURL(e.target.files[3]));
      $("#image4").attr("src", URL.createObjectURL(e.target.files[4]));
    }
  })
  const policy_fn = () => {
    $("#policy_modal").modal("show");
  }

</script>
</html>
