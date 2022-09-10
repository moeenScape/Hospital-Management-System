import decimal
from django.db import connection
import os
import django
    


def classroom_requirement_course_offer(semester, year):
    sections=[]
    with connection.cursor() as cursor:
       
        cursor.execute('''
        SELECT COUNT(*) AS Sections
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 1 AND 10
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 11 AND 20
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 21 AND 30
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 31 AND 35
        AND semester = %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 36 AND 40
        AND semester = %s
        AND year =  %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 41 AND 50
        AND semester = %s
        AND year =%s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 51 AND 55
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 56 AND 65
        AND semester =  %s
        AND year = %s''',[semester,year,semester,year,semester,year,semester,year,semester,year,semester,year,semester,year,semester,year])
        sections=[]
        ro = cursor.fetchall()
        print(ro)
        for sec in ro:
            sec = (sec[0])
            print(sec)
            sections.append(sec) 
        return sections 


def IUB_resource_usage(semester,year):
     with connection.cursor() as cursor:
       
        cursor.execute(
        ''' SELECT SUM(seasapp_section_t.enrolled) AS Enroller,
            COUNT(seasapp_section_t.sectionNo) AS Section,
            SUM(seasapp_room_t.roomSize)
            FROM seasapp_section_t,seasapp_course_t,seasapp_room_t
            WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID 
            AND seasapp_section_t.roomID_id = seasapp_room_t.roomID 
            AND seasapp_section_t.semester=%s
            AND seasapp_section_t.year=%s
            GROUP BY seasapp_course_t.schoolTitle_id;
        ''',[semester,year])
        sections = []
        enrolled = []
        roomcap = []
        waste = []
        percent = []
        ro = cursor.fetchall()
        print(ro)
        for roll,sec,room in ro:
            print(roll)
            sections.append(roll) 
            aven = int(roll/sec)
            print(aven)
            enrolled.append(aven)
            aver = int(room/sec)
            roomcap.append(aver)
            was = aver - aven
            waste.append(was)
            des=int((was*100)/aver)
            percent.append(des)
        usage = {
            'sections':sections,
            'enrolled':enrolled,
            'roomcap': roomcap,
            'waste':waste ,
            'percent':percent
        }
        print(usage)
        return usage 

def IUB_Available_resource():
     with connection.cursor() as cursor:
       
        cursor.execute('''
        SELECT seasapp_room_t.roomSize,COUNT(seasapp_room_t.roomID)
        FROM seasapp_room_t
        WHERE seasapp_room_t.roomSize IN (20,30,35,40,50,54,65)
        GROUP BY seasapp_room_t.roomSize
        ''')
        ro = cursor.fetchall()
        room=[]
        space=[]
        for r,s in ro:
            room.append(r)
            space.append(s)
        dic = {
            'room':room,
            'space':space
        }
        print(dic)
        return dic 

def class_size_based_sections(semester,year):
    with connection.cursor() as cursor:
        cursor.execute('''
    CREATE VIEW Section AS 
    SELECT COUNT(*) AS Sections
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 1 AND 20
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 21 AND 30
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 31 AND 35
        AND semester = %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 36 AND 40
        AND semester = %s
        AND year =  %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 41 AND 50
        AND semester = %s
        AND year =%s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 51 AND 55
        AND semester =  %s
        AND year = %s
        UNION 
        SELECT COUNT(*)
        FROM seasapp_section_t 
        WHERE capacity BETWEEN 56 AND 65
        AND semester =  %s
        AND year = %s''',[semester,year,semester,year,semester,year,semester,year,semester,year,semester,year,semester,year])
        sections=[]
        ro = cursor.fetchall()
        print(ro)
        for sec in ro:
            sec = (sec[0])
            print(sec)
            sections.append(sec) 
        return sections 


# def sections_based_on_enrolled(semester,year,school):
#     with connection.cursor() as cursor:
#         cursor.execute('''
#         SELECT seasapp_section_t.enrolled,COUNT(seasapp_section_t.sectionNo) AS Section
#         FROM seasapp_section_t,seasapp_course_t
#         WHERE seasapp_section_t.courseID_id= seasapp_course_t.courseID 
#         AND seasapp_section_t.year = %s
#         AND seasapp_section_t.semester = %s 
#         AND seasapp_course_t.schoolTitle_id = %s
#         GROUP BY seasapp_section_t.enrolled;
#         ''',[year,semester,school])
#         ro = cursor.fetchall()
#         print(ro)
#         return ro 


def enrollment_wise_course_distribution(semester,year,school):


   with connection.cursor() as cursor:
       
        cursor.execute('''
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 1 AND 10
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 11 AND 20
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 21 AND 30
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 31 AND 35
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 36 AND 40
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 41 AND 50
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 51 AND 55
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 56 AND 60
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        UNION ALL
        SELECT COUNT(*) AS school
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.enrolled BETWEEN 61 AND 100
        AND semester = %s
        AND year = %s
        AND seasapp_course_t.schoolTitle_id = %s
        ''',[semester,year,school,semester,year,school,semester,year,school,semester,year,school,semester,year,school,semester,year,school,semester,year,school,semester,year,school,semester,year,school])
        ro = cursor.fetchall()
        print(ro)
        enrolled=[]
        for sec in ro:
            sec = (sec[0])
            print(sec)
            enrolled.append(sec) 
        return enrolled

def IUB_revenue(semester,year,school):
    with connection.cursor() as cursor:
       
        cursor.execute('''
        SELECT SUM(seasapp_course_t.creditHour*seasapp_section_t.enrolled)
        FROM seasapp_section_t,seasapp_course_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_section_t.semester= %s
        AND seasapp_section_t.year= %s
        AND seasapp_course_t.schoolTitle_id= %s
        ''',[semester,year,school])
        ro = cursor.fetchall()
       
        r = (ro[0][0])
        
           
        return r


def engineering_school_revenue(semester,year,dept):
    with connection.cursor() as cursor:
       
        cursor.execute('''
        SELECT SUM(seasapp_course_t.creditHour*seasapp_section_t.enrolled)
        FROM seasapp_section_t,seasapp_course_t,seasapp_department_t
        WHERE seasapp_section_t.courseID_id = seasapp_course_t.courseID
        AND seasapp_course_t.departmentName_id = 	seasapp_department_t.departmentName
        AND seasapp_section_t.semester= %s
        AND seasapp_section_t.year=%s
        AND seasapp_course_t.schoolTitle_id= "SETS"          
		AND seasapp_department_t.departmentName=%s
        ''',[semester,year,dept])
        ro = cursor.fetchall()
       
        r = (ro[0][0])
        
           
        return r