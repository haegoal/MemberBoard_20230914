package com.icia.board.controller;

import com.icia.board.dto.BoardDTO;
import com.icia.board.dto.BoardFileDTO;
import com.icia.board.dto.MemberDTO;
import com.icia.board.dto.MemberFileDTO;
import com.icia.board.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.Member;
import java.util.List;

@Controller
@RequestMapping("/member")
public class MemberController {
    @Autowired
    private MemberService memberService;

    @GetMapping("/login")
    public String login(){
        return "login";
    }

    @GetMapping("/findLogin")
    public String findLogin(@ModelAttribute MemberDTO memberDto,@RequestParam("bid") Long bid , Model model){
        System.out.println("memberDto = " + memberDto + ", model = " + model);
        model.addAttribute("member", memberDto);
        model.addAttribute("bid", bid);
        return "findLogin";
    }

    @GetMapping("/save")
    public String save(){
        return "save";
    }

    @GetMapping("/findMember")
    public ResponseEntity findMember(@RequestParam("id") Long id){
        System.out.println("id = " + id);
        MemberDTO memberDTO = memberService.findMember(id);
        if(memberDTO!=null){
            return new ResponseEntity<>(memberDTO, HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }


    @GetMapping("/findAll")
    public ResponseEntity findEmail(){
        List<MemberDTO> memberDTOList = memberService.findAll();
        if(memberDTOList!=null){
            return new ResponseEntity<>(memberDTOList, HttpStatus.OK);
        }else{
            return new ResponseEntity<>(null, HttpStatus.OK);
        }
    }


    @GetMapping("/read")
    public String read(@RequestParam("id") Long memberId,Model model) {
        MemberDTO memberDTO = memberService.findMember(memberId);
        model.addAttribute("u", memberDTO);
        if (memberDTO.getFileAttached() == 1) {
            List<MemberFileDTO> memberFileDTOList = memberService.findFile(memberId);
            model.addAttribute("memberFileList", memberFileDTOList);
        }
        return "read";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute MemberDTO memberDTO) throws IOException {
        memberService.save(memberDTO);
        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response){
        session.removeAttribute("user");
        session.removeAttribute("userId");
        Cookie cookie=new Cookie("memberId", "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        return "redirect:/";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute MemberDTO memberDTO) throws IOException {
        System.out.println("memberDTO = " + memberDTO);
        memberService.update(memberDTO);
        return "redirect:/";
    }

    @PostMapping("/login")
    public ResponseEntity login(@ModelAttribute MemberDTO memberDTO, @RequestParam("keep") boolean keep, HttpSession session, HttpServletResponse response){
        boolean login = memberService.login(memberDTO);
        if(login){
            Long id = memberService.findId(memberDTO);
            System.out.println(id);
            session.setAttribute("user", memberDTO.getMemberEmail());
            session.setAttribute("userId", id);
            if(keep){
                Cookie cookie=new Cookie("memberEmail", memberDTO.getMemberEmail());
                cookie.setMaxAge(60*60*24*7);
                cookie.setPath("/");
                response.addCookie(cookie);
            }
            return new ResponseEntity<>(memberDTO, HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

}
