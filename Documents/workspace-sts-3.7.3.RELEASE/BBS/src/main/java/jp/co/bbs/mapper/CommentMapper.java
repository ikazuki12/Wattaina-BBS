package jp.co.bbs.mapper;

import java.util.List;

import jp.co.bbs.dto.CommentDto;

public interface CommentMapper {

	void commentInsert(CommentDto commentDto);
	List<CommentDto> getComments();
	void deleteComment(int id);
	void deleteMessageComment(int id);
	CommentDto getComment();
}