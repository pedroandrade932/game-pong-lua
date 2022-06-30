-- title:   Pong Game Remake
-- author:  Pedro G. H. Andrade
-- desc:    A remake of the 72's Pong Arcade game (2 players).
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 1.1
-- script:  lua

game = {
	w = 240,
	h = 136,
	mapa = {
		x = 0,
		y = 0
	},
}

player = {
	x = 0,
	y = game.h // 2,
	points = 0,
	sprs = 256,
	fr = 1,
	px = 2,
	invs = 0,
	reflet = 0,
	pro = 1,
	vyp = 1,
	vyn = 1,
	ky = 0,
	draw = function(self)
		spr(0%(30*self.fr)//30*self.px+self.sprs,
		self.x,self.y,self.invs,self.pro,self.reflet,1,3,1)
	end,
	move = function(self)
		if btn(0) and self.y > 0 then 
			self.y = self.y - self.vyn
		end
		if btn(1) and (self.y+24) < 136 then
			self.y = self.y + self.vyp
		end
	end
}

player2 = {
	x = 232,
	y = game.h // 2,
	points = 0,
	sprs = 272,
	fr = 1,
	px = 2,
	invs = 0,
	reflet = 0,
	pro = 1,
	vyp = 1,
	vyn = 1,
	ky = 0,
	draw = function(self)
		spr(0%(30*self.fr)//30*self.px+self.sprs,
		self.x,self.y,self.invs,self.pro,self.reflet,1,3,1)
	end,
	move = function(self)
		if input == 'keyboard' then
			if btn(4) and self.y > 0 then 
				self.y = self.y - self.vyn
			end
			if btn(5) and (self.y+24) < 136 then
				self.y = self.y + self.vyp
			end
		end
		if input == 'gamepad' then
			if btn(8) and self.y > 0 then 
				self.y = self.y - self.vyn
			end
			if btn(9) and (self.y+24) < 136 then
				self.y = self.y + self.vyp
			end
		end
	end
}

ball = {
	t = 0,
	x = game.w // 2,
	y = game.h // 2,
	sprs = 259,-- Sprite inicial
	fr = 1,-- Frames
	px = 2,-- Pixels
	invs = 0,-- Cor invisivel
	reflet = 0,-- Refletido
	pro = 1,-- Proporcao
	vx = 1,-- vel. x
	vy = 1,-- vel. y
	sx = -1,
	sy = 0,
	tock = false,
	mov_h = function(sx)
		move = ball.x + sx
		return move
	end,
	mov_v = function(sy)
		move = ball.y + sy
		return move
	end,
	
	draw = function(self)
		spr(self.t%(30*self.fr)//30*self.px+self.sprs,
		self.x,self.y,self.invs,self.pro,self.reflet,1,1,1)
	end,	
	move = function(self)
			self.x = self.mov_h(ball.sx)
			self.y = self.mov_v(ball.sy)
			
			-- Collision walls
			if self.y <= 0 then
				self.sy = 1
				sfx(0, 37, 8, 0, 5)
			elseif self.y+8 >= 136 then
				self.sy = -1
				sfx(0, 37, 8, 0, 5)
			end
			-- Collision Players
			if self.x <= player.x + 6 then
				if CheckCollision(self.x, self.y, 1)
				then
					if ball.tock == false then
						self.sy = -1
						ball.tock = true
					end
					if self.y+4 >= player.y and self.y+4 <= player.y + 4 then	
						self.sy = -1
					end
					if self.y+4 >= player.y + 20 and self.y+4 <= player.y + 24 then	
						self.sy = 1
					end
					self.sx = 1
					sfx(0, 40, 8, 0, 5)
				end
			end
			if self.x + 6 >= player2.x then
				if CheckCollision(self.x, self.y, 2)
				then
					if ball.tock == false then
						self.sy = -1
						ball.tock = true
					end
					if self.y+4 >= player2.y and self.y+4 <= player2.y + 4 then	
						self.sy = -1
					end
					if self.y+4 >= player2.y + 20 and self.y+4 <= player2.y + 24 then	
						self.sy = 1
					end
					self.sx = -1
					sfx(0, 40, 8, 0, 5)
				end
			end
	end
}


function CheckCollision(x, y, p)
	local collision = false
	if p == 1 then
		if y+4 >= player.y and y+4 <= player.y + 24 then	
			collision = true
		end
	else
		if y+4 >= player2.y and y+4 <= player2.y + 24 then	
			collision = true
		end
	end
	return collision
end

function Point()
	if ball.x < -9 then
		player2.points = player2.points + 1
		ball.x = game.w // 2
		ball.y = game.h // 2
		ball.sy = 0
		ball.tock = false
	elseif ball.x > 249 then
		player.points = player.points + 1
		ball.x = game.w // 2
		ball.y = game.h // 2
		ball.sy = 0
		ball.tock = false
	end
end

menu = true
input = 'keyboard'

function TIC()
	cls(0)
	if menu then
		rect(game.w//2, 0, 1, 136, 12)
		player:draw()
		player2:draw()
		if player.y >= 0 and player.y+25 <= 136 or
			player2.y >= 0 and player2.y+25 <= 136 then
			player.y = ball.y
			player2.y = ball.y
		elseif ball.y <= 112 then
			player.y = ball.y
			player2.y = ball.y
		end
		ball:draw()
		ball:move()
		
		print('Pong Game', 70, 30, 4, 1, 2)
		print('Remake', 150, 41, 4, 1, 1, 1)
		print('2 Players', 98, 50, 4)
		print('Press Z(A) to play with keyboard', 60, 60, 4, 1, 1, 1)
		print('P1: up and down  P2: Z and X', 65, 70, 1, 1, 1, 1)
		print('Press X(B) to play with gamepad', 61, 80, 4, 1, 1, 1)
		print('P1: up and down  P2: up and down', 60, 90, 1, 1, 1, 1)
		if btn(4) then
			input = 'keyboard'
			menu = false
			player.y = game.h // 2
			player2.y = game.h // 2
			ball.x = game.w // 2
			ball.y = game.h // 2
			ball.sx = -1
			ball.sy = 0
			ball.tock = false
		elseif btn(5) then
			input = 'gamepad'
			menu = false
			player.y = game.h // 2
			player2.y = game.h // 2
			ball.x = game.w // 2
			ball.y = game.h // 2
			ball.sx = -1
			ball.sy = 0
			ball.tock = false
		end
	else
		-- Game Layout
		rect(game.w//2, 0, 1, 136, 12)
		print(player.points, 45, 10, 10, 1, 2)
		print(player2.points, 185, 10, 3, 1, 2)
		Point()
		
		-- Game Checks
		if input == 'keyboard' then
			spr(260, 40, 120, 0, 1, 0, 0, 1, 1)
			spr(261, 50, 120, 0, 1, 0, 0, 1, 1)
			spr(262, 170, 120, 0, 1, 0, 0, 1, 1)
			spr(263, 180, 120, 0, 1, 0, 0, 1, 1)
		else
			spr(260, 40, 120, 0, 1, 0, 0, 1, 1)
			spr(261, 50, 120, 0, 1, 0, 0, 1, 1)
			spr(260, 170, 120, 0, 1, 0, 0, 1, 1)
			spr(261, 180, 120, 0, 1, 0, 0, 1, 1)
		end
		
		player:draw()
		player:move()
		player2:draw()
		player2:move()
		ball:draw()
		ball:move()
	end
end
