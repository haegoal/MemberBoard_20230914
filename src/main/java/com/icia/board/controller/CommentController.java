package com.icia.board.controller;

import com.icia.board.dto.CommentDTO;
import com.icia.board.dto.MemberDTO;
import com.icia.board.service.CommentService;
import com.icia.board.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;

    @GetMapping("/delete")
    public ResponseEntity ddelete(@RequestParam("id") Long id) {
            commentService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @PostMapping("/delete")
    public ResponseEntity delete(@ModelAttribute CommentDTO commentDTO) {
        System.out.println(commentDTO);
        commentDTO = commentService.find(commentDTO);
        System.out.println(commentDTO);
        if(commentDTO!=null){
            commentService.delete(commentDTO.getId());
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>( HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/save")
    public ResponseEntity save(@ModelAttribute CommentDTO commentDTO) {
        System.out.println("commentDTO = " + commentDTO);
        commentService.save(commentDTO);
        List<CommentDTO> commentDTOList = commentService.findAll(commentDTO.getBoardId());
        System.out.println(commentDTOList);
        return new ResponseEntity<>(commentDTOList, HttpStatus.OK);
    }
}