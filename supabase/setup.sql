-- ============================================
-- AIC CATHEDRAL COMPREHENSIVE SCHOOL
-- PARENTS PORTAL SECURITY SETUP
-- ============================================


-- Enable Row Level Security
-- ============================================

ALTER TABLE public.parents
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.student_parents
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.students
ENABLE ROW LEVEL SECURITY;


-- ============================================
-- PARENTS
-- A parent can only see their own parent record.
-- ============================================

DROP POLICY IF EXISTS "Parents can view own record"
ON public.parents;

CREATE POLICY "Parents can view own record"
ON public.parents
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
);


-- ============================================
-- STUDENT-PARENTS
-- A parent can only see links belonging
-- to their own parent account.
-- ============================================

DROP POLICY IF EXISTS "Parents can view own children links"
ON public.student_parents;

CREATE POLICY "Parents can view own children links"
ON public.student_parents
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.parents p
        WHERE p.id = student_parents.parent_id
        AND p.user_id = auth.uid()
    )
);


-- ============================================
-- STUDENTS
-- A parent can only see students linked
-- to their own parent account.
-- ============================================

DROP POLICY IF EXISTS "Parents can view linked students"
ON public.students;

CREATE POLICY "Parents can view linked students"
ON public.students
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.student_parents sp
        INNER JOIN public.parents p
            ON p.id = sp.parent_id
        WHERE sp.student_id = students.id
        AND p.user_id = auth.uid()
    )
);


-- ============================================
-- END
-- ============================================
