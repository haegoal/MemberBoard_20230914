<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css">
    <link rel="stylesheet" href="/resources/css/style2.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
</head>
<body>
<div class="container">
    <div class="row ms-2">
        <jsp:include page="header.jsp"></jsp:include>
    </div>
    <div class="row ms-2">
        <h2 class="mt-4 ms-2" style="color: #333D77; font-weight:900;">Member Board &copy;</h2>
        <hr style="border: solid 3px #333D77;">
    </div>
    <div class="row ms-2">
        <div class="col" style="font-size: 20px">${board.boardTitle}</div>
    </div>
    <div class="row ms-2">
        <div class="col" style="font-size: 15px">
            ${board.boardWriter}
        </div>
        <div class="col">
            ${board.createdAt}
        </div>
        <div class="col">
            조회 ${board.boardHits}
        </div>
        <hr style="border: solid 2px">
    </div>
    <div class="row ms-2">
        <div class="col">
            <c:if test="${board.fileAttached == 1}">
                <c:forEach items="${boardFileList}" var="boardFile">
                    <img src="${pageContext.request.contextPath}/upload/${boardFile.storedFileName}"
                         alt="" width="500" height="500">
                </c:forEach>
            </c:if>
        </div>
    </div>
    <div class="row ms-4 mb-5">
        ${board.boardContents}
    </div>

    <div class="row justify-content-end">
        <div class="col-2" style="display:flex">
            <c:if test="${board.boardWriter == user or member==null}">
                <button onclick="board_update()" class="btn btn-primary m-1">수정</button>
                <button onclick="board_delete()" class="btn btn-primary m-1">삭제</button>
            </c:if>
            <button onclick="board_list()" class=" btn btn-primary m-1">목록</button>
        </div>
    </div>
    <hr style="border: solid 2px">

    <div class="text-end" id="pass-check" style="display: none;">
        <input type="text" id="board-pass" placeholder="(수정)비밀번호 입력하세요">
        <input type="button" onclick="pass_check()" value="확인">
    </div>

    <div class="text-end" id="pass-dcheck" style="display: none;">
        <input type="text" id="board-dpass" placeholder="(삭제)비밀번호 입력하세요">
        <input type="button" onclick="pass_dcheck()" value="확인">
    </div>

    <div class="table input-group mt-5">
        <div style="width:300px;height:175px;">
            <c:choose>
                <c:when test="${user!=null}">
                    <input type="text" id="comment-writer" value="${user}">
                    <input type="hidden" id="comment-password" value=null>
                </c:when>
                <c:otherwise>
                    <input type="text" id="comment-writer" placeholder="작성자 입력">
                    <input type="password" id="comment-password" placeholder="비번입력 입력">
                </c:otherwise>
            </c:choose>

        </div>
        <div>
            <textarea id="comment-contents" rows="4" cols="80"
                      placeholder="타인의 권리를 침해하거나 명예를 훼손하는 댓글은 운영원칙 및 관련 법률에 제재를 받을 수 있습니다."></textarea>
            <button class="btn btn-primary mb-4" onclick="comment_write()">댓글작성</button>
        </div>
        <div>
        </div>
    </div>
    <hr style="border: solid 2px">

    <div id="comment-list-area" class="mt-5">
        <c:choose>
        <c:when test="${commentList == null}">
            <h3 class="text-center">작성된 댓글이 없습니다.</h3>
        </c:when>
        <c:otherwise>
        <div id="comment-list">
            <c:forEach items="${commentList}" var="comment">
            <div class="row">
                <div class="col">${comment.commentWriter}</div>
                <div class="col">${comment.commentContents}</div>
                <div class="col">${comment.commentCreatedDate}</div>
                <c:if test="${user == comment.commentWriter or comment.memberId ==null}">
                <div class="col text-end">
                    <div class="col text-end"><i class="bi bi-x-square-fill" style='cursor: pointer'
                                                 onclick="delete_fn('${comment.id}', '${comment.memberId}')"></i></div>
                    </c:if>
                </div>
                <hr class="mt-5" style="border: solid 2px">
                </c:forEach>
            </div>
            </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<div class="modal fade" id="modal-comment" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
     aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="password" placeholder="비밀번호입력해주세요." id="modal-compw">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="comment_delete">삭제</button>
            </div>
        </div>
    </div>
</div>
</body>
<script>

    const user = '${user}';

    const comment_write = () => {
        const commentWriter = document.getElementById("comment-writer").value;
        const commentContents = document.querySelector("#comment-contents").value;
        const boardId = '${board.id}';
        const memberId = '${userId}';
        const commentPassword = document.querySelector("#comment-password").value
        const result = document.getElementById("comment-list-area");
        if (commentWriter == "") {
            alert("작성자 입력바람!")
        } else if (commentPassword == "") {
            alert("비번입력바람!")
        } else if (commentContents == "") {
            alert("내용입력바람")
        } else {
            $.ajax({
                type: "post",
                url: "/comment/save",
                data: {
                    commentWriter,
                    commentContents,
                    boardId,
                    commentPassword,
                    memberId,
                },
                success: function (res) {
                    let output = "<div id=\"comment-list\">\n"
                    console.log(res.memberId)
                    for (let i in res) {
                        console.log(res[i])
                        output += "    <div class=\"row\" >\n";
                        output += "        <div class=\"col\">" + res[i].commentWriter + "</div>\n";
                        output += "        <div class=\"col\">" + res[i].commentContents + "</div>\n";
                        output += "        <div class=\"col\">" + res[i].commentCreatedDate + "</div>\n";
                        if (res[i].memberId == null || user == res[i].commentWriter) {
                            output += "        <div class=\"col\"><i class='bi bi-x-square-fill' style='cursor: pointer' onclick=\"delete_fn(" + res[i].id + "," + null + ")\"></i></div>\n";
                        }
                        output += "        <hr class=\"mt-5\" style=\"border: solid 2px\">";
                        output += "    </div>\n";
                    }
                    output += "</div>";
                    result.innerHTML = output;
                    if (user == null) {
                        document.getElementById("comment-writer").value = "";
                        document.getElementById("comment-password").value = "";
                    }
                    document.getElementById("comment-contents").value = "";
                },
                error: function () {
                    console.log("댓글 작성 실패");
                }
            });
        }
    }

    const delete_fn = (id, memberId) => {
        if (memberId == "" || memberId == null) {
            $("#modal-comment").modal("show");
            $("#comment_delete").on("click", function () {
                const commentPassword = document.getElementById("modal-compw").value;
                console.log(id, commentPassword);
                $.ajax({
                    type: "post",
                    data: {id, commentPassword},
                    url: "/comment/delete",
                    success: function () {
                        $("#modal-comment").modal("hide");
                        alert("삭제완료");
                        location.href = "/board?id=${board.id}&page=${paging.page}&query=${query}&key=${key}"
                    }, error: function () {
                        alert("비밀번호가 일치하지않습니다.");
                    }
                })
            })
        } else if (memberId == '${userId}') {
            $.ajax({
                type: "get",
                data: {id},
                url: "/comment/delete",
                success: function () {
                    alert("삭제완료");
                    location.href = "/board?id=${board.id}&page=${paging.page}&query=${query}&key=${key}"
                }
            })
        }
    }


    const board_list = () => {
        const page = '${page}';
        const q = '${q}';
        const type = '${type}';
        location.href = "/board/list?page=" + page + "&q=" + q + "&type=" + type;
    }
    const board_update = () => {
        if (user == '${board.boardWriter}') {
            if (confirm("수정하시겠습니까?")) {
                const id = '${board.id}'
                location.href = "/board/update?id=" + id;
            }
        } else {
            const id = '${board.boardId}';
            $.ajax({
                type: "get",
                url: "/member/findMember",
                data: {id},
                success: function (data) {
                    const memberEmail = data.memberEmail;
                    const memberPassword = data.memberPassword;
                    console.log(data)
                    location.href = "/member/findLogin?memberEmail=" + memberEmail + "&memberPassword=" + memberPassword + "&bid=${board.id}";
                }, error: function () {
                    const passArea = document.getElementById("pass-check");
                    const passDarea = document.getElementById("pass-dcheck");
                    passArea.style.display = "block";
                    passDarea.style.display = "none";
                }
            })
        }
    }
    const board_delete = () => {
        if (user == '${board.boardWriter}') {
            if (confirm("삭제하시겠습니까?")) {
                const id = '${board.id}';
                location.href = "/board/delete?id=" + id
            }
        } else {
            const id = '${board.boardId}';
            $.ajax({
                type: "get",
                url: "/member/findMember",
                data: {id},
                success: function (data) {
                    const memberEmail = data.memberEmail;
                    const memberPassword = data.memberPassword;
                    console.log(data)
                    location.href = "/member/findLogin?memberEmail=" + memberEmail + "&memberPassword=" + memberPassword + "&bid=${board.id}";
                }, error: function () {
                    const passDarea = document.getElementById("pass-dcheck");
                    const passArea = document.getElementById("pass-check");
                    passDarea.style.display = "block";
                    passArea.style.display = "none";
                }
            })
        }
    }
    const pass_check = () => {
        const inputPass = document.getElementById("board-pass").value;
        const pass = '${board.boardPass}';
        const id = '${board.id}';
        if (inputPass == pass) {
            if (confirm("수정하시겠습니까?")) {
                location.href = "/board/update?id=" + id;
            }
        } else {
            alert("비밀번호 불일치!");
        }
    }

    const pass_dcheck = () => {
        const inputPass = document.getElementById("board-dpass").value;
        const pass = '${board.boardPass}';
        const id = '${board.id}';
        if (inputPass == pass) {
            if (confirm("삭제하시겠습니까?")) {
                location.href = "/board/delete?id=" + id;
            }
        } else {
            alert("비밀번호 불일치!");
        }
    }
</script>
</html>