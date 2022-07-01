/datum/job_listing
	var/name
	var/desc
	var/datum/job/overflow_role_job
	var/overflow_role
	/// List of all departments with joinable jobs.
	var/list/datum/job_department/joinable_departments = list()
	/// List of all joinable departments indexed by their typepath, sorted by their own display order.
	var/list/datum/job_department/joinable_departments_by_type = list()
	/// List of jobs that can be joined through the starting menu.
	var/list/datum/job/joinable_occupations = list()
	/// List of jobs that can be joined through the starting menu, associative by type.
	var/list/datum/job/joinable_occupations_by_type = list()
	/// List of all the job types that should be initialzied for this listing
	var/list/jobs = list()
	/// Landmarks for latejoining
	var/list/latejoin_trackers = list()
	/// Landmarks for starting points
	var/list/start_landmarks_list = list()
	/// Landmarks for starting points
	var/list/jobspawn_overrides = list()
	/// Whether the job listing will be started and its occupations divided on the start of the round
	var/setup_on_roundstart = TRUE

/datum/job_listing/New()
	. = ..()
	SetupOccupations()
	SetOverflowRole(overflow_role_job)

/datum/job_listing/proc/GetJobType(passed_type)
	return joinable_occupations_by_type[passed_type]

/datum/job_listing/proc/SetupOccupations()
	var/list/new_joinable_occupations = list()
	var/list/new_joinable_departments = list()
	var/list/new_joinable_departments_by_type = list()
	for(var/iterated_type in jobs)
		var/datum/job/job = new iterated_type(src)
		new_joinable_occupations += job
		joinable_occupations_by_type[iterated_type] = job
		if(!LAZYLEN(job.departments_list))
			var/datum/job_department/department = new_joinable_departments_by_type[/datum/job_department/undefined]
			if(!department)
				department = new /datum/job_department/undefined()
				new_joinable_departments_by_type[/datum/job_department/undefined] = department
			department.add_job(job)
			continue
		for(var/department_type in job.departments_list)
			var/datum/job_department/department = new_joinable_departments_by_type[department_type]
			if(!department)
				department = new department_type()
				new_joinable_departments_by_type[department_type] = department
			department.add_job(job)
	sortTim(new_joinable_departments_by_type, /proc/cmp_department_display_asc, associative = TRUE)
	for(var/department_type in new_joinable_departments_by_type)
		var/datum/job_department/department = new_joinable_departments_by_type[department_type]
		sortTim(department.department_jobs, /proc/cmp_job_display_asc)
		new_joinable_departments += department
	joinable_occupations = sortTim(new_joinable_occupations, /proc/cmp_job_display_asc)
	joinable_departments = new_joinable_departments
	joinable_departments_by_type = new_joinable_departments_by_type

/datum/job_listing/proc/SetOverflowRole(new_overflow_role_type)
	if(new_overflow_role_type == null)
		overflow_role = null
		return
	var/datum/job/new_overflow_role = GetJobType(new_overflow_role_type)
	if(!new_overflow_role)
		return
	var/cap = CONFIG_GET(number/overflow_cap)

	new_overflow_role.allow_bureaucratic_error = FALSE
	new_overflow_role.spawn_positions = cap
	new_overflow_role.total_positions = cap

	if(new_overflow_role == overflow_role_job)
		return
	var/datum/job/old_overflow = GetJobType(overflow_role)
	old_overflow.allow_bureaucratic_error = initial(old_overflow.allow_bureaucratic_error)
	old_overflow.spawn_positions = initial(old_overflow.spawn_positions)
	old_overflow.total_positions = initial(old_overflow.total_positions)
	overflow_role_job = new_overflow_role
	overflow_role = new_overflow_role_type

/datum/job_listing/proc/get_department_type(department_type)
	return joinable_departments_by_type[department_type]

/datum/job_listing/settlers
	name = "Settlers"
	desc = "Buncha settlers."
	jobs = list(
		/datum/job/assistant,
		)
