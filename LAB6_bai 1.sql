create trigger checkluong_nv on nhanvien for insert as
if (select luong from inserted) < 15000
begin
print'Tien luong toi thieu phai hon 15000'
rollback transaction
end
go




create trigger check_themnv ON NHANVIEN for insert as 
declare @tuoi int
set @tuoi=year(getdate()) - (select year(NGSINH) from inserted)
if (@tuoi < 18 or @tuoi > 65 )
begin
print'Yêu cầu nhập tuổi từ 18 đến 65'
rollback transaction 
end
go




create trigger update_NV on NHANVIEN for update as
IF (SELECT DCHI FROM inserted ) like '%TP HCM%'
begin
print'Không thể cập nhật'
rollback transaction
end