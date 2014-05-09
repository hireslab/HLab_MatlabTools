  function [M0,Faxial,t,varargout] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
                whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %   DHO 6/18/10 NOTE: This should be rewritten using inputParser. 
            %
            % USAGE:
            %
            %    function [M0,Faxial,t] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,varargout] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,deltaKappa] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,deltaKappa,Fnorm] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,deltaKappa,Fnorm,thetaAtBase] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,deltaKappa,Fnorm,thetaAtBase,thetaAtContact] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,deltaKappa,Fnorm,thetaAtBase,thetaAtContact,distanceToPoleCenter] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %    function [M0,Faxial,t,deltaKappa,Fnorm,thetaAtBase,thetaAtContact,distanceToPoleCenter, meanKappa] = calc_M0_Faxial(obj,tid,r_point,whisker_radius_at_base,...
            %      whisker_length,youngs_modulus,baseline_time_or_kappa_value)
            %
            %
            % INPUTS:
            %
            % 	tid:  trajectory ID or string specifying the whisker the use.
            % 	r_point: radial distance along whisker at which to measure kappa. In mm.
            % 	whisker_radius_at_base: Given in microns.
            % 	whisker_length: Given in mm.
            % 	youngs_modulus: In Pa.
            % 	baseline_time_or_kappa_value: Either (1) a 1x2 vector giving starting and stopping times (inclusive) for measuring baseline whisker curvature, in sec; 
            %                                 or (2) a scaler giving a baseline kappa value (measured by the user separately) to directly subtract from kappa
            %                                 timeseries, in 1/mm.
            %
            % OUTPUTS:
            %
            % 	M0:  Moment at the follicle. In Newton-meters.
            % 	Faxial: Axial force into follice. In Newtons.
            % 	t: The time of each M0, Faxial observation. In sec.
            %
            % 	Optionally,
            %
            % 	deltaKappa = Change from baseline curvature, at point specified by r_point. In 1/mm.
            % 	Fnorm - The force on the whisker normal to the contacted object. In Newtons.
            %   thetaAtBase - The whisker angle nearest the follicle. In degrees.
            %   thetaAtContact - The whisker angle nearest the point of contact. I.e., nearest the center of the pole. In degrees.
            %   distanceToPoleCenter - The closest distance between the whisker and the center of the pole. In mm.
            %   meanKappa - The mean of kappa over the entire secondary polynomial fitted ROI. In 1/mm.
            %
            % REQUIRES:
            % 	-Follicle coordinates are already computed.
            % 	-Property pxPerMm is set correctly for the current videographic conditions.
            % 	-Property faceSideInImage is set correctly.
            % 	-Property barPos is set correctly.
            %
            % Assumptions:
            % 	-Whisker is conical.
            %   -Young's modulus is same everywhere on whisker.
            %   -Whisker cross-section is circular.
            %
            %
            if isnumeric(tid) % Trajectory ID specified.
                ind = find(obj.trajectoryIDs == tid);
            elseif ischar(tid) % Whisker name specified.
                ind = strmatch(tid,obj.whiskerNames,'exact');
            else
                error('Invalid type for argument ''tid''.')
            end
            
            if isempty(ind)
                error('Could not find specified trajectory ID.')
            end
            
            if isempty(obj.follicleCoordsX) || isempty(obj.follicleCoordsX)
                error(['obj.follicleCoordsX or obj.follicleCoordsY is empty. ' ...
                    'Must run obj.recompute_cached_follicle_coords before this method.'])
            end
            
            if isempty(obj.barPos)
                error('obj.barPos is empty. Bar position is required to define point of contact.')
            end
            
            r_point = r_point * 1e-3; % Argument given in mm; convert to meters.
            whisker_radius_at_base = whisker_radius_at_base * 1e-6; % Argument given in micrometers; convert to meters.
            whisker_length = whisker_length * 1e-3;  % Argument given in mm; convert to meters.
            
            pixelsPerMeter = 1e3 * obj.pxPerMm;
            
            II = pi/4*(whisker_radius_at_base*(1-r_point/whisker_length))^4; % In Meters^4. Eqn A2,3 from Birdwell et al.
            EI = youngs_modulus*II; % Meter^4-pascals. Bending stiffness at point r_point.
            
            x0 = obj.follicleCoordsX{ind};
            y0 = obj.follicleCoordsY{ind};
            
            if isempty(x0) || isempty(y0)
              disp(['No follicle coordinates computed for tid ' int2str(tid) ', cannot compute forces, setting to NaN.'])
              t = obj.time{ind};
              x0 = nan(size(t));
              y0 = nan(size(t));
            end

            
            % Could speed up by combining next few lines, since several call arc_length_theta_and_kappa().
            % From one function call, need to get:
            %   t, theta0, kappaPoint, yPoint, xPoint, meanKappa (from ROIKAPPA), thetaContact, yContact, xContact, distanceToPoleCenter 
            
            FC = obj.get_force_calc_vals(tid, r_point*1e3); % Give r_point argument in mm.
            
            % get_force_calc_vals() combines:
            %            [theta0,tmp,t] = obj.get_theta_kappa_at_base(tid);
            %            [tmp,kappaPoint,yPoint,xPoint,t] = obj.get_theta_kappa_at_roi_point(tid,r_point*1e3)
            %            [tmp1,thetaContact,tmp2,yContact,xContact,distanceToPoleCenter,t] = obj.get_r_theta_kappa_nearest_bar(tid);
            %
            % FC is structure with fields: t (sec), theta0 (degrees), kappaPoint (1/pixels), yPoint (pixels), xPoint (pixels),
            % meanKappa (in ROI; 1/pixels), thetaContact (degrees), yContact (pixels), xContact (pixels), distanceToPoleCenter (pixels).
                        % Construct output structure:
                        
            t = FC.t; % In sec
            theta0 = FC.theta0; % In degrees
            kappaPoint = FC.kappaPoint; % In 1/pixels
            yPoint = FC.yPoint; % In pixels
            xPoint = FC.xPoint; % In pixels
            meanKappa = FC.meanKappa; % In 1/pixels.
            thetaContact = FC.thetaContact; % In 1/pixels
            yContact = FC.yContact; % In pixels
            xContact = FC.xContact; % In pixels
            distanceToPoleCenter = FC.distanceToPoleCenter; % In pixels
            
            
%             [theta0,tmp,t] = obj.get_theta_kappa_at_base(tid);
            
%             [tmp,kappaPoint,yPoint,xPoint,t] = obj.get_theta_kappa_at_roi_point(tid,r_point*1e3); % Give second argument in mm. kappaPoint in 1/pixels.
            
            if numel(baseline_time_or_kappa_value)==2
                disp(['Using kappa averaged over times ' num2str(baseline_time_or_kappa_value(1)) ' to ' num2str(baseline_time_or_kappa_value(2)) ...
                    ' (inclusive) for baseline kappa for trajectory ID ' int2str(tid) '.'])
                baselineKappa = pixelsPerMeter * nanmean(kappaPoint(t >= baseline_time_or_kappa_value(1) & t <= baseline_time_or_kappa_value(2))); % Now in 1/m.
            elseif numel(baseline_time_or_kappa_value)==1
                disp(['Using user-specified kappa value of ' num2str(baseline_time_or_kappa_value) ' 1/mm for baseline kappa for trajectory ID ' int2str(tid) '.'])
                baselineKappa = baseline_time_or_kappa_value * 1e3; % baseline_time_or_kappa_value given in 1/mm; convert to 1/m.
            else 
                error('Argument ''baseline_time_or_kappa_value'' has wrong number of elements.')
            end
            
            kappaPoint = pixelsPerMeter * kappaPoint - baselineKappa; % In 1/m.
            
%             [tmp,tmp1,ROIKAPPA] = obj.arc_length_theta_and_kappa_in_roi(tid);
%             meanKappa = cellfun(@mean, ROIKAPPA); % In 1/pixels.
            
            meanKappa = pixelsPerMeter * meanKappa - baselineKappa;
            
%             [tmp1,thetaContact,tmp2,yContact,xContact,distanceToPoleCenter,t] = obj.get_r_theta_kappa_nearest_bar(tid);
            
            theta0 = theta0*(2*pi/360); % Convert all angles to radians.
            thetaContact = thetaContact*(2*pi/360);
            
            rPointNorm = sqrt((xContact-xPoint).^2 + (yContact-yPoint).^2) / pixelsPerMeter; % in meters.
            r0Norm = sqrt((xContact-x0).^2 + (yContact-y0).^2) / pixelsPerMeter; % in meters.
            
            %**** CHECK: NEED TO ACCOUNT FROM PROTRACTION DIRECTION IN FOLLOWING? *******
            
            % Get angle of vector from r_point to contact point:
            dx = (xContact-xPoint); dy = (yContact-yPoint);
            if strcmp(obj.faceSideInImage,'top') || strcmp(obj.faceSideInImage,'bottom')
                thetaPoint2Cont = atan(dx./dy);
            else
                thetaPoint2Cont = atan(dy./dx);
            end
            
            % Get angle of vector from follicle to contact point:
            dx = (xContact-x0); dy = (yContact-y0);
            if strcmp(obj.faceSideInImage,'top') || strcmp(obj.faceSideInImage,'bottom')
                thetaFoll2Cont = atan(dx./dy);
            else
                thetaFoll2Cont = atan(dy./dx);
            end
            
            Fnorm = (kappaPoint*EI) ./ (rPointNorm .* sin(pi/2 + thetaPoint2Cont - thetaContact)); % in Newtons
            Faxial = Fnorm.*sin(theta0 - thetaContact); % in Newtons.
            M0 = r0Norm.*Fnorm.*sin(pi/2 + thetaFoll2Cont - thetaContact); % in Newton-meters
            
            if nargout > 3
                varargout{1} = kappaPoint / 1e3; % kappaPoint in 1/m; return in 1/mm.
            end
            if nargout > 4
                varargout{2} = Fnorm;
            end
            if nargout > 5
                varargout{3} = theta0 / (2*pi/360); % Whisker angle nearest the follicle. Currently in radians; return in degrees.
            end
            if nargout > 6
                varargout{4} = thetaContact / (2*pi/360); % Whisker angle at point nearest center of pole. Currently in radians; return in degrees.
            end
            if nargout > 7
                varargout{5} = distanceToPoleCenter / obj.pxPerMm; % distanceToPoleCenter in pixels; return in mm.
            end
            if nargout > 8
               varargout{6} = meanKappa / 1e3; % meanKappa in 1/m; return in 1/mm.
            end
        end