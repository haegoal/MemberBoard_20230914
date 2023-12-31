package com.icia.board.service;

import com.icia.board.dto.BoardFileDTO;
import com.icia.board.dto.MemberDTO;
import com.icia.board.dto.MemberFileDTO;
import com.icia.board.repository.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Member;
import java.util.List;

@Service
public class MemberService {
    @Autowired
    private MemberRepository memberRepository;

    public boolean login(MemberDTO memberDTO) {
        memberDTO= memberRepository.login(memberDTO);
        if(memberDTO!=null){
            return true;
        }else{
            return false;
        }
    }
    public void save(MemberDTO memberDTO) throws IOException {
        if(memberDTO.getMemberProfile()==null){
            memberDTO.setFileAttached(0);
            memberRepository.save(memberDTO);
        }else {
            memberDTO.setFileAttached(1);
            MemberDTO saveMember = memberRepository.save(memberDTO);
            for (MultipartFile memberProfile : memberDTO.getMemberProfile()) {
                String originalFilename = memberProfile.getOriginalFilename();
                String storedFileName = System.currentTimeMillis() + "-" + originalFilename;
                MemberFileDTO memberFileDTO = new MemberFileDTO();
                memberFileDTO.setOriginalFileName(originalFilename);
                memberFileDTO.setStoredFileName(storedFileName);
                memberFileDTO.setMemberId(saveMember.getId());
                System.out.println(memberFileDTO);
                String savePath = "C:\\spring_img\\" + storedFileName;
                memberProfile.transferTo(new File(savePath)); //실제 파일옴겨주는 메소드
                memberRepository.saveFile(memberFileDTO);
            }
        }
    }

    public MemberDTO findEmail(String memberEmail) {
        return memberRepository.findEmail(memberEmail);
    }

    public Long findId(MemberDTO memberDTO) {
        return memberRepository.findId(memberDTO);
    }

    public MemberDTO findMember(Long id) {
        return memberRepository.findMember(id);
    }

    public List<MemberDTO> findAll() {
        return memberRepository.findAll();
    }

    public List<MemberFileDTO> findFile(Long memberId) {
        return memberRepository.findFile(memberId);
    }

    public void update(MemberDTO memberDTO) throws IOException {
        if(memberDTO.getMemberProfile()==null){
            memberDTO.setFileAttached(0);
            memberRepository.update(memberDTO);
        }else {
            memberDTO.setFileAttached(1);
            MemberDTO saveMember = memberRepository.update(memberDTO);
            for (MultipartFile memberProfile : memberDTO.getMemberProfile()) {
                String originalFilename = memberProfile.getOriginalFilename();
                String storedFileName = System.currentTimeMillis() + "-" + originalFilename;
                MemberFileDTO memberFileDTO = new MemberFileDTO();
                memberFileDTO.setOriginalFileName(originalFilename);
                memberFileDTO.setStoredFileName(storedFileName);
                memberFileDTO.setMemberId(saveMember.getId());
                System.out.println(memberFileDTO);
                String savePath = "C:\\spring_img\\" + storedFileName;
                memberProfile.transferTo(new File(savePath)); //실제 파일옴겨주는 메소드
                memberRepository.saveFile(memberFileDTO);
            }
        }
    }
}
