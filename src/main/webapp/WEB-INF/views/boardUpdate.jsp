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
  <form class="card p-3" action="/board/save" method="post" enctype="multipart/form-data" name="frm">
    <div class="row m-5">
      <div class="col">
        <c:choose>
          <c:when test="${user!=null}">
            <input class="mt-3" type="hidden" name="boardId" value="${userId}" readonly><br>
            <input class="mt-3" type="text" name="boardWriter" value="${user}" readonly><br>
          </c:when>
          <c:otherwise>
            <input class="mt-3" type="text" name="boardWriter" placeholder="글작성자">
            <input class="mt-3" type="password" name="boardPass" placeholder="비밀번호"><br>
          </c:otherwise>
        </c:choose>
        <input class="mt-3 mb-1" type="text" name="boardTitle" placeholder="제목을 입력해 주세요."><br>
        <h6> 쉬운 비밀번호를 입력하면 타인의 수정, 삭제가 쉽습니다. </h6>
        <span class="mb-5"> 음란물, 차별, 비하, 혐오 및 초상권, 저작권 침해 게시물은 민, 형사상의 책임을 질 수 있습니다.    </span><span onclick="policy_fn()" style="font-weight:900; cursor: pointer ">[저작권법 안내]</span>
        <br><br><br>
        <div class="col-md-12">
          <textarea class="form-control" rows="8" cols="100" name="boardContents"></textarea><br>
        </div>
        <input class="mt-2" type="file" name="boardFile" multiple><br>
        <div class="text-end">
          <input class="mt-3" type="submit" value="등록" class="btn btn-primary">
          <input class="mt-3"  type="reset" value="취소" class="btn btn-secondary">
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
  const policy_fn = () => {
    $("#policy_modal").modal("show");
  }
</script>
</html>
