<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div class="container">
    <div class="row">
    <jsp:include page="header.jsp"></jsp:include>
    </div>
    <form class="card me-4" action="/member/save" method="post" enctype="multipart/form-data" name="frm">
        <div class="row m-3">
            <div class="col">
        <div class="row">
        <div class="col-md-6">
            <div class="input-group">
            <span class="input-group-text">이메일</span>
            <input class="form-control" type="text" class="form-control" name="memberEmail" id="member-email" onblur="checkId_fn()" autocomplete='off' minlength="10" maxlength='25'>
            </div>
        </div>
        </div>
                <p id="id-check"></p>
        <div class="row mt-3">
        <div class="col-md-6">
            <div class="input-group">
            <span class="input-group-text">비밀번호</span>
            <input class="form-control" type="password" class="form-control" name="memberPassword" id="member-password" onblur="check_fn()" autocomplete='off' maxlength='25'>
        </div>
        </div>
        </div>
                <p id="p-check"></p>
        <div class="row mt-3">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">이름</span>
                    <input class="form-control" type="text" class="form-control" name="memberName" id="member-name" autocomplete='off' maxlength='12' oninput='isKor(this)'/>
            </div>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">생일</span>
                     <input class="form-control" type="date" class="form-control" name="memberBirth" id="member-birth" autocomplete='off'>
            </div>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">전화번호</span>
                <input class="form-control" type="text" class="form-control" name="memberMobile" id="member-mobile" autocomplete='off' minlength="11" maxlength="11"  oninput='isNumber(this);'>
            </div>
        </div>
        </div>
        <div class="row mt-3">
            <div class="col">
                    <label for="member-profile" class="form-label">프로필사진</label>
                <input class="form-control" type="file" class="form-control" name="memberProfile" id="member-profile" autocomplete='off' multiple accept="image/*">
            </div>
        </div>
        </div>
            <div class="col">
                <img src = "http://via.placeholder.com/120x150" width="40%" id="image">
            </div>
        </div>
        <div class="row m-3">
            <div class="col-md-6 text-end">
                <button class="btn btn-primary">가입</button>
            </div>
        </div>
    </form>
</div>

</body>
<script>

    $(frm.memberProfile).on("change", function(e){
        $("#image").attr("src", URL.createObjectURL(e.target.files[0]));
    })

    let idc = 0;

    const checkId_fn = () => {
        const email = document.getElementById("member-email").value;
        const idckeck = document.getElementById("id-check");
        const emailRegex = /^[A-Za-z0-9]+@[A-Za-z0-9]+\.[A-Za-z]{2,4}$/;
        if(email.length == 0) {
            idckeck.innerHTML = "";
        }else{
            if (email.includes("@") && emailRegex.test(email)) {
                $.ajax({
                    type:"get",
                    url:"/member/findemail",
                    data:{email},
                    success:function(){
                        idc=1;
                        idckeck.innerHTML = "중복된 이메일입니다.";
                        idckeck.style.color = "red";
                    },error:function (){
                        idc=0;
                        idckeck.innerHTML = "올바른 이메일입니다.";
                        idckeck.style.color = "blue";
                    }
                })
            } else {
                idckeck.innerHTML = "이메일형식으로 입력바람.";
                idckeck.style.color = "red";
            }
        }
    }

    const check_fn = () => {
        const pw = document.getElementById("member-password").value;
        const pckeck = document.getElementById("p-check");
        const regex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]+$/;
        if (pw.length == 0) {
            pckeck.innerHTML = "";
        }else{
            if (regex.test(pw) && pw.length > 0) {
                pckeck.innerHTML = "올바른 비밀번호입니다.";
                pckeck.style.color = "blue";
            } else {
                pckeck.innerHTML = "영소문자, 특수문자, 숫자가 포함되어야합니다.";
                pckeck.style.color = "red";
            }
        }
    }


    $(frm).on("submit", function(e){
        e.preventDefault();
        const memberEmail = document.querySelector('#member-email').value;
        const memberPassword = document.querySelector('#member-password').value;
        const memberName = document.querySelector('#member-name').value;
        const memberBirth = document.querySelector('#member-birth').value;
        const memberMobile = document.querySelector('#member-mobile').value;
        const regex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]+$/;
        const emailRegex = /^[A-Za-z0-9]+@[A-Za-z0-9]+\.[A-Za-z]{2,4}$/;
        if(memberEmail ==""){
            alert("이메일입력바람");
            $(frm.memberEmail).focus();
        }else if(!(memberEmail.includes("@")) && !(emailRegex.test(memberEmail))){
            alert("이메일형식으로입력바람");
            $(frm.memberEmail).focus();
        }else if(idc!=0){
            alert("이메일이중복되었습니다.");
            $(frm.memberEmail).focus();
        } else if (memberPassword==""){
            alert("비번입력바람!");
            $(frm.memberPassword).focus();
        }else if(!(regex.test(memberPassword))){
            alert("비번형식으로입력바람");
            $(frm.memberPassword).focus();
        }else if(memberName==""){
            alert("이름입력바람");
            $(frm.memberName).focus();
        }else if(memberBirth==""){
            alert("생년월일입력바람");
            $(frm.memberBirth).focus();
        }else if(memberMobile==""){
            alert("전화번호입력바람");
            $(frm.memberMobile).focus();
        }else{
           frm.submit();
        }
    })

    function isKor(item)  {
        item.value = item.value.replace(/[^ㄱ-ㅎ|가-힣]/g, '')
    }


    function isNumber(item){
        item.value=item.value.replace(/[^0-9]/g,'');
    }
</script>
</html>
