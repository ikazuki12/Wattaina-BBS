package jp.co.bbs.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jp.co.bbs.dto.CommentDto;
import jp.co.bbs.mapper.CommentMapper;


@Service
public class CommentService {

	@Autowired
	private CommentMapper commentMapper;
	
	public void commentInsert(Integer userId, int messageId, String text, Date date){
		CommentDto commentDto = CommentDto.getInstance(userId, messageId, text, date);
		commentMapper.commentInsert(commentDto);
	}
	
	public List<CommentDto> getComments() {
		List<CommentDto> ret = commentMapper.getComments();
		return ret;
	}
	
	public void deleteComment(int id) {
		commentMapper.deleteComment(id);
	}
	
	public void deleteMessageComment(int id) {
		commentMapper.deleteMessageComment(id);
	}
	
	public CommentDto getComment() {
		CommentDto ret = commentMapper.getComment();
		return ret;
	}
}
