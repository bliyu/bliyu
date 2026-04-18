---@param s SpriteState
return function(s)
  return {
    sprite = Res.sprites.PLAYER:state {
      pos = s.pos,
      size = s.size or Vec2.new(36, 11),
      starting_origin = s.starting_origin,
      rot = s.rot,
      frame_idx = s.frame_idx,
      flip_x = s.flip_x,
      flip_y = s.flip_y,
    },
    prev_box = Box.zero(),
    input_x = 0,
    speed = 0.4 * S.camera.box.w,
  }
end
