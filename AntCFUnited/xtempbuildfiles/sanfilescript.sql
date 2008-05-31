--declare @filelist varchar(8000)
--select @filelist = COALESCE(@filelist + ',','') + 
select
PhysicalFileName

from j_templatesections_attachmentlocations_locationtypes big
		join attachmentlocations al on big.locationid = al.locationid
		join j_templatesections_attachmentlocations_attachments big2 on 
big.locationid=big2.locationid
		join attachments a on big2.attachmentid=a.attachmentid
		where locationtypeid=1


--select @filelist
