----------------Bài 1-----------------------




----------------Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000-------------
create trigger Themnv ON NHANVIEN for insert as 
if (select LUONG from inserted )<15000
begin 
print 'Lương phải >15000'
rollback transaction 
end
go




-----------Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.-------------
create trigger check_themnv ON NHANVIEN for insert as 
declare @tuoi int
set @tuoi=year(getdate()) - (select year(NGSINH) from inserted)
if (@tuoi < 18 or @tuoi > 65 )
begin
print'Yêu cầu nhập tuổi từ 18 đến 65'
rollback transaction 
end
go



---------------Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM---------------------
create trigger update_NV on NHANVIEN for update as
IF (SELECT DCHI FROM inserted ) like '%TP HCM%'
begin
print'Không thể cập nhật'
rollback transaction
end
go





----------------------Bài 2----------------------------------------





-------------------Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động thêm mới nhân viên.-------------------
create trigger trg_TongNV
   on NHANVIEN
   AFTER INSERT
AS
   Declare @male int, @female int;
   select @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
   select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
   print N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
   print N'Tổng số nhân viên là nam: ' + cast(@male as varchar);
go



-----------------------------Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động cập nhật phần giới tính nhân viên------------
create trigger trg_TongNVSauUpdate
   on NHANVIEN
   AFTER update
AS
   if (select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted)
   begin
      Declare @male int, @female int;
      select @female = count(Manv) from NHANVIEN where PHAI = N'Nữ';
      select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
      print N'Tổng số nhân viên là nữ: ' + cast(@female as varchar);
      print N'Tổng số nhân viên là nam: ' + cast(@male as varchar);
   end;
go



--------------Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng DEAN----------------
CREATE TRIGGER trg_TongNVSauXoa on DEAN
AFTER DELETE
AS
begin
   SELECT MA_NVIEN, COUNT(MADA) as 'Số đề án đã tham gia' from PHANCONG
      GROUP BY MA_NVIEN
	  end
	  select * from DEAN
go



--------------Bài 3----------------------






-------------Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân viên trong bảng nhân viên.---------------
create trigger delete_thannhan on NHANVIEN
instead of delete
AS
begin
	delete from THANNHAN where MA_NVIEN in(select manv from deleted)
	delete from NHANVIEN where manv in(select manv from deleted)
end
go



-------------------Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA là 1.--------------
create trigger nhanvien3 on NHANVIEN
after insert 
as
begin
insert into PHANCONG values ((select manv from inserted), 1,2,20)
end