package com.icia.board.controller;

import com.icia.board.dto.*;
import com.icia.board.service.BoardService;
import com.icia.board.service.CommentService;
import com.icia.board.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {
    @Autowired
    private MemberService memberService;

    @Autowired
    private BoardService boardService;
    @Autowired
    private CommentService commentService;

    @GetMapping("/save")
    public String save(){
        return "boardSave";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") Long id){
        boardService.delete(id);
        return "redirect:/board/list";
    }

    @GetMapping("/update")
    public String update(@RequestParam("id") Long id,Model model){
        BoardDTO boardDTO = boardService.findById(id);
        model.addAttribute("board", boardDTO);
        if (boardDTO.getFileAttached() == 1) {
            List<BoardFileDTO> boardFileDTOList = boardService.findFile(id);
            model.addAttribute("boardFileList", boardFileDTOList);
            System.out.println(boardFileDTOList);
        }
        return "boardUpdate";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute BoardDTO boardDTO) throws IOException {
        boardService.update(boardDTO);
        return "redirect:/board/list";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute BoardDTO boardDTO) throws IOException {
        boardService.save(boardDTO);
        return "redirect:/board/list";
    }

    @GetMapping
    public String findById(@RequestParam("id") Long id,
                           @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                           @RequestParam(value = "q", required = false, defaultValue = "") String q,
                           @RequestParam(value = "type", required = false, defaultValue = "boardTitle") String type,
                           Model model) {
        boardService.updateHits(id);
        BoardDTO boardDTO = boardService.findById(id);
        MemberDTO memberDTO = memberService.findEmail(boardDTO.getBoardWriter());
        List<MemberDTO> memberDTOList = memberService.findAll();
        model.addAttribute("board", boardDTO);
        model.addAttribute("member", memberDTO);
        model.addAttribute("members", memberDTOList);
        System.out.println(memberDTOList);
        if (boardDTO.getFileAttached() == 1) {
            List<BoardFileDTO> boardFileDTOList = boardService.findFile(id);
            model.addAttribute("boardFileList", boardFileDTOList);
            System.out.println(boardFileDTOList);
        }

        List<CommentDTO> commentDTOList = commentService.findAll(id);
        if (commentDTOList.size() == 0) {
            model.addAttribute("commentList", null);
        } else {
            model.addAttribute("commentList", commentDTOList);
        }
        model.addAttribute("q", q);
        model.addAttribute("type", type);
        model.addAttribute("page", page);
        return "boardDetail";
    }

    @GetMapping("/list")
    public String list(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
                       @RequestParam(value = "query", required = false, defaultValue = "") String query,
                       @RequestParam(value = "key", required = false, defaultValue = "boardTitle") String key,
                       Model model){

        List<BoardDTO> boardDTOList =null;
        PageDTO pageDTO = null;

        if(query.equals("")){
            boardDTOList = boardService.paginglist(page);
            pageDTO = boardService.pageNumber(page);
            System.out.println(pageDTO.getMaxPage());
        }else{
            boardDTOList = boardService.search(key, query, page);
            pageDTO = boardService.searchPageNumber(key, query, page);
        }
        model.addAttribute("boardList", boardDTOList);
        model.addAttribute("paging", pageDTO);
        model.addAttribute("query", query);
        model.addAttribute("page", page);
        return "boardList";
    }


}


